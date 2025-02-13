//
//  ImageCacheManager.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/13/25.
//

import Foundation
import SwiftUI

// Image Cache Helper
class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = URLCache.shared
    
    func getImage(for url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        if let cachedResponse = cache.cachedResponse(for: request) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
    
    func saveImage(_ data: Data, for url: URL) {
        let request = URLRequest(url: url)
        let response = CachedURLResponse(response: URLResponse(url: url, mimeType: "image/jpeg", expectedContentLength: data.count, textEncodingName: nil), data: data)
        cache.storeCachedResponse(response, for: request)
    }
}


// AsyncImage with Manual Caching
struct CachedAsyncImageView: View {
    let url: URL
    @State private var image: UIImage? = nil

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .shadow(radius: 2)
            } else {
                ProgressView()
                    .onAppear {
                        Task {
                            await loadImage()
                        }
                    }
            }
        }
    }

    private func loadImage() async {
        if let cachedImage = ImageCacheManager.shared.getImage(for: url) {
            print("Cached Image")
            image = cachedImage
        } else {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let downloadedImage = UIImage(data: data) {
                        ImageCacheManager.shared.saveImage(data, for: url)
                        image = downloadedImage
                    } else {
                        print("Failed to decode image data")
                    }
                } else {
                    print("Failed to load image, status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                }
            } catch {
                print("Failed to load image: \(error)")
            }
        }
    }

}
