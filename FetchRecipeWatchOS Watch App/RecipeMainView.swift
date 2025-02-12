//
//  RecipeMainView.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//

import Foundation
import SwiftUI
import CoreData


struct RecipeMainView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Recipes...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text(error)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await viewModel.fetchRecipes()
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.recipes.isEmpty {
                    Text("No recipes available.")
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Load the filters other comps, when we
                    // Fetched the data and its present
                    // Pass the recipes fetched to the List View
                    
                    // Also have filters and serach options later
                    RecipeListView(recipes: viewModel.recipes)
                }
            }
            .navigationTitle("Recipes")
            // Automatically fetch recipes when the view appears.
            .task {
                await viewModel.fetchRecipes()
            }
        }
    }
}

