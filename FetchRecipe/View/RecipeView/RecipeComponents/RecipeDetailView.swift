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
    @State private var showAIModal = false
    @State private var showShareSheet = false
    
    // Create a sharing message that includes recipe details
    private var sharingText: String {
        "Check out this amazing \(recipe.name) recipe from \(recipe.cuisine) cuisine!"
    }
    
    var body: some View {
        ScrollView {
            VStack {
                // Content Section
                VStack(spacing: 24) {
                    // Header Info
                    HStack(spacing: 16) {
                        Text(recipe.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text(recipe.cuisine)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(20)
                            .bold()
                            .foregroundColor(.accent)
                    }
                    
                    // Video Section
                    if let youtubeUrl = recipe.youtubeUrl,
                       let embedUrl = getYouTubeEmbedUrl(youtubeUrl) {
                        VStack(alignment: .leading, spacing: 8) {
                            YouTubeView(youtubeURL: embedUrl)
                                .frame(height: 200)
                                .cornerRadius(12)
                                .shadow(radius: 2)
                        }
                    }
                    
                    // Quick Actions
                    HStack(spacing: 16) {
                        Button(action: { showAIModal.toggle() }) {
                            VStack(spacing: 4) {
                                Image(systemName: "message.circle.fill")
                                    .font(.system(size: 24))
                                Text("Ask AI")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                        }
                        

                        if let sourceUrl = recipe.sourceUrl {
                            Link(destination: sourceUrl) {
                                VStack(spacing: 4) {
                                    Image(systemName: "doc.text.fill")
                                        .font(.system(size: 24))
                                    Text("Full Recipe")
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.green.opacity(0.1))
                                .foregroundColor(.green)
                                .cornerRadius(12)
                            }
                        }

                        
                        if let linkToUse = recipe.sourceUrl ?? recipe.photoUrlLarge ?? URL(string: "https://example.com"){
                            Button(action: {
                                showShareSheet = true
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 24))
                                    Text("Share")
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.purple.opacity(0.1))
                                .foregroundColor(.purple)
                                .cornerRadius(12)
                            }
                            
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAIModal) {
            AskAIModalView(recipe: recipe)
        }
        .sheet(isPresented: $showShareSheet, content: {
                let linkToUse = recipe.sourceUrl ?? recipe.photoUrlLarge ?? URL(string: "https://example.com")!

                ShareSheet(items: [sharingText, linkToUse])
        })
    }
    
    func getYouTubeEmbedUrl(_ url: URL) -> URL? {
        guard let videoID = url.absoluteString.components(separatedBy: "v=").last?.components(separatedBy: "&").first else {
            return nil
        }
        let embedUrlString = "https://www.youtube.com/embed/\(videoID)"
        return URL(string: embedUrlString)
    }
}

// Add this ShareSheet struct to handle sharing
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
