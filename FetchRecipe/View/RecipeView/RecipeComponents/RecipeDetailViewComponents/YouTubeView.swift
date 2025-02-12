//
//  YouTubeView.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//

import Foundation
import SwiftUI
import WebKit

struct YouTubeView: UIViewRepresentable {
    let youtubeURL: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.load(URLRequest(url: youtubeURL))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

