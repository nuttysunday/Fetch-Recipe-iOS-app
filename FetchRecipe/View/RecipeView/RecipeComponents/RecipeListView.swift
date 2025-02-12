//
//  RecipeListView.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//

import Foundation
import SwiftUI
import CoreData


struct RecipeListView: View {
    let recipes: [Recipe]

    var body: some View {
            List(recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    HStack {
                        AsyncImage(url: recipe.photoUrlSmall) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(12)
                                    .clipped()
                            } else if phase.error != nil {
                                Image(systemName: "photo")
                                    .frame(width: 80, height: 80)
                            } else {
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            }
                        }

                        VStack(alignment: .leading) {
                            Text(recipe.name)
                                .font(.headline)
                            Text(recipe.cuisine)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            
    }
}
