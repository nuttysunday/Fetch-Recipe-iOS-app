//
//  RecipeMainView.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//

import Foundation
import SwiftUI
import CoreData



enum RecipeSortOption: String, CaseIterable {
    case nameAZ = "Name (A-Z)"
    case nameZA = "Name (Z-A)"
    case cuisineAZ = "Cuisine (A-Z)"
    case cuisineZA = "Cuisine (Z-A)"
}

struct RecipeMainView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    @State private var selectedSortOption: RecipeSortOption = .nameAZ
    @State private var searchText: String = ""
    @State private var selectedCuisines: Set<String> = []  // Multi-select cuisine filter
    @State private var isCuisineFilterPresented = false    // Controls sheet presentation
    @State private var showShareSheet = false
    
    // Computed property to return sorted recipes
    var sortedRecipes: [Recipe] {
        let sorted = switch selectedSortOption {
        case .nameAZ:
            viewModel.recipes.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .nameZA:
            viewModel.recipes.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        case .cuisineAZ:
            viewModel.recipes.sorted { $0.cuisine.localizedCaseInsensitiveCompare($1.cuisine) == .orderedAscending }
        case .cuisineZA:
            viewModel.recipes.sorted { $0.cuisine.localizedCaseInsensitiveCompare($1.cuisine) == .orderedDescending }
        }
        return sorted
    }
    
    // Computed property to return filtered recipes based on search query and selected cuisines
    var filteredRecipes: [Recipe] {
        sortedRecipes.filter { recipe in
            let matchesSearch = searchText.isEmpty ||
            recipe.name.localizedCaseInsensitiveContains(searchText) ||
            recipe.cuisine.localizedCaseInsensitiveContains(searchText)
            
            let matchesCuisine = selectedCuisines.isEmpty || selectedCuisines.contains(recipe.cuisine)
            
            return matchesSearch && matchesCuisine
        }
    }
    
    // Extract unique cuisines for filtering
    var availableCuisines: [String] {
        let cuisines = Set(viewModel.recipes.map { $0.cuisine })
        return Array(cuisines).sorted()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                VStack {

                    // Search Bar
                    TextField("Search recipes...", text: $searchText)
                        .padding(10)
                        .cornerRadius(8)
                        .overlay(
                            HStack {
                                Spacer()
                                if !searchText.isEmpty {
                                    Button(action: { searchText = "" }) {
                                        Image(systemName: "xmark.circle.fill")
                                    }
                                    .padding(.trailing, 8)
                                }
                            }
                        )
                }
                .padding(.horizontal)
                
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
                    } else if filteredRecipes.isEmpty {
                        Text("No recipe found")
                    } else {
                        RecipeListView(recipes: filteredRecipes)
                            .refreshable {
                            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1.5 seconds delay
                            await viewModel.fetchRecipes()
                        }
                    }
                }
            }
           
            .navigationBarTitle("")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showShareSheet = true
                    }) {
                        Image(systemName: "square.and.arrow.up") // Share icon
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Text("FetchRecipes")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.accentColor, .accentColor.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(color: .gray.opacity(0.4), radius: 2, x: 0, y: 2)
                }

            }
            //.border(.red)
            .task {
                await viewModel.fetchRecipes()
            }
        }
    }
}


