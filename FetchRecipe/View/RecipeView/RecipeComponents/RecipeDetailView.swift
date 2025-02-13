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
                    
                    // Image Section
                    if let imageUrl = recipe.photoUrlLarge {
                        VStack(alignment: .leading, spacing: 8) {
                            AsyncImage(url: imageUrl) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(12)
                                        .shadow(radius: 2)
                                case .failure:
                                    Image(systemName: "photo.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                    
                    
                    // Quick Actions
                    QuickActionList(recipe: recipe)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    
}

