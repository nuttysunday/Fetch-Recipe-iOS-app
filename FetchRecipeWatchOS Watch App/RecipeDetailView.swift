//
//  RecipeDetailView.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//

import Foundation
import SwiftUI
import WatchKit


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
                
                Divider()
            
            
            
                if let sourceUrl = recipe.sourceUrl {
                    Link("View Full Recipe", destination: sourceUrl)
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                
            
                Button("VDuumy") {
                            let dummyURLString = "https://www.apple.com" // Or any other URL you want to test
                            
                            if let dummyURL = URL(string: dummyURLString) {
                                // Open the URL using WKExtension on watchOS
                                WKExtension.shared().openSystemURL(dummyURL)
                            } else {
                                print("Invalid dummy URL string") // Handle the unlikely case of an invalid URL string
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.blue)

                
            }
            .padding()
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}
