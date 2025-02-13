
// Loads the Detail view for the Recipe Selected from Recipe List View
// Title, Image, Quick Actions (AI, Video, Recipe, Share Icon)

import Foundation
import SwiftUI

// Main
struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                RecipeDetailTitleView(recipe: recipe) // Title Section
                RecipeDetailCoverView(recipe: recipe) // Image Section
                QuickActionList(recipe: recipe) // Quick Actions
            }
            .padding()
        }
    }
}



// TITLE
struct RecipeDetailTitleView: View {
    let recipe: Recipe
    
    var body: some View {
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
    }
}

// COVER IMAGE
// Updated RecipeDetailCoverView with CachedAsyncImage
struct RecipeDetailCoverView: View {
    let recipe: Recipe
    
    var body: some View {
        if let imageUrl = recipe.photoUrlLarge {
            CachedAsyncImageView(url: imageUrl)
        } else {
            Image(systemName: "photo.fill")
                .font(.system(size: 24))
                .foregroundColor(.gray)
        }
    }
}

// QUICK ACTIONS LIST
struct QuickActionList: View {
    let recipe: Recipe
    @State private var showAIModal = false
    @State private var showShareSheet = false
    
    // Create a sharing message that includes recipe details
    private var sharingText: String {
        "Check out this amazing \(recipe.name) recipe from \(recipe.cuisine) cuisine!"
    }
    
    var body: some View {
        HStack(spacing: 16){
            Button(action: { showAIModal.toggle() }) {
                QuickActionButton(imageName: "message.circle.fill", color: .blue, text: "Ask AI")
            }.sheet(isPresented: $showAIModal) {
                AskAIModalView(recipe: recipe)
            }
            
            if let sourceUrl = recipe.youtubeUrl {
                Link(destination: sourceUrl) {
                    QuickActionButton(imageName: "video.fill", color: .red, text: "Video")
                }
            } else{
                QuickActionButton(imageName: "video.fill", color: .gray, text: "Video")
            }
            
            if let sourceUrl = recipe.sourceUrl {
                Link(destination: sourceUrl) {
                    QuickActionButton(imageName: "doc.text.fill", color: .green, text: "Recipe")
                }
            } else{
                QuickActionButton(imageName: "doc.text.fill", color: .gray, text: "Recipe")
            }
            
            if (recipe.sourceUrl ?? recipe.photoUrlLarge) != nil{
                Button(action: {
                    showShareSheet = true
                }) {
                    QuickActionButton(imageName: "square.and.arrow.up", color: .purple, text: "Share")
                }
                .sheet(isPresented: $showShareSheet, content: {
                    let linkToUse = recipe.sourceUrl ?? recipe.photoUrlLarge ?? URL(string: "https://example.com")!
                    ShareSheet(items: [sharingText, linkToUse])
                })
            }
        }
    }
}


// QUICK ACTION LIST BUTTON
struct QuickActionButton: View {
    let imageName: String
    let color: Color
    let text: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: imageName)
                .font(.system(size: 24))
                .foregroundColor(color)
            Text(text)
                .font(.caption)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
