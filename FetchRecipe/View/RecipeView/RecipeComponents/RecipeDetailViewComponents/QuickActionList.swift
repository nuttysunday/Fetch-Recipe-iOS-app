//
//  QuickActionList.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/12/25.
//

import Foundation
import SwiftUI


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
            }

        }
        .sheet(isPresented: $showAIModal) {
            AskAIModalView(recipe: recipe)
        }
        .sheet(isPresented: $showShareSheet, content: {
            let linkToUse = recipe.sourceUrl ?? recipe.photoUrlLarge ?? URL(string: "https://example.com")!
            ShareSheet(items: [sharingText, linkToUse])
        })
    }
    
}


