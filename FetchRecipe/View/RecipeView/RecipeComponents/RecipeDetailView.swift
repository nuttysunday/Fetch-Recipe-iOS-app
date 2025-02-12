//
//  RecipeDetailView.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//

import Foundation
import SwiftUI


struct RecipeDetailView: View {
    let recipe: Recipe
    
    @State private var showAIModal = false  // Controls the visibility of the modal
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Display Recipe Image
                if let imageUrl = recipe.photoUrlLarge {
                    AsyncImage(url: imageUrl) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 250)
                                .clipped()
                                .cornerRadius(12)
                        } else {
                            ProgressView()
                        }
                    }
                }

                // Recipe Name
                Text(recipe.name)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Cuisine Type
                Text("Cuisine: \(recipe.cuisine)")
                    .font(.title2)
                    .foregroundColor(.secondary)

                Divider()
                
                Button(action: {
                    showAIModal.toggle()
                }) {
                    Text("Ask Gemini")
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .cornerRadius(12)
                }
                
                Divider()
            
                
                // YouTube Video Embed (if available)
                if let youtubeUrl = recipe.youtubeUrl, let embedUrl = getYouTubeEmbedUrl(youtubeUrl) {
                    YouTubeView(youtubeURL: embedUrl)
                        .frame(width: 250, height: 150)
                        .cornerRadius(12)
                }
                
            
                if let sourceUrl = recipe.sourceUrl {
                    Link("View Full Recipe", destination: sourceUrl)
                        .font(.headline)
                        .foregroundColor(.blue)
                }

                
            }
            .padding()
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAIModal) {
            AskAIModalView(recipe: recipe)
        }
    }
    
    // Converts a YouTube URL to an embeddable URL
    func getYouTubeEmbedUrl(_ url: URL) -> URL? {
        guard let videoID = url.absoluteString.components(separatedBy: "v=").last?.components(separatedBy: "&").first else {
            return nil
        }
        return URL(string: "https://www.youtube.com/embed/\(videoID)")
    }
}
