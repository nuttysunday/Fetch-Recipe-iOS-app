//
//  RecipeMainView.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//

import SwiftUI
import Lottie

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
                    // Search Bar, Sort, and Cuisine Filter in Horizontal Stack
                    HStack() {
                        // Dropdown Menu for Sorting
                        Menu {
                            ForEach(RecipeSortOption.allCases, id: \.self) { option in
                                Button(action: { selectedSortOption = option }) {
                                    Text(option.rawValue)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedSortOption.rawValue)
                                Image(systemName: "chevron.down")
                            }
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }

                        // Button to open Cuisine Multi-Select Filter
                        Button(action: { isCuisineFilterPresented = true }) {
                            HStack {
                                Text(selectedCuisines.isEmpty ? "All Cuisines" : "\(selectedCuisines.count) Selected")
                                Image(systemName: "line.3.horizontal.decrease.circle")
                            }
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)

                    // Search Bar
                    TextField("Search recipes...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            HStack {
                                Spacer()
                                if !searchText.isEmpty {
                                    Button(action: { searchText = "" }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
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
                        LottieView(animation: .named("EmptyAnimation"))
                            .playing(loopMode: .loop)
                    } else {
                        RecipeListView(recipes: filteredRecipes)
                    }
                }
            }
            .navigationTitle("Recipes")
            .task {
                await viewModel.fetchRecipes()
            }
            .sheet(isPresented: $isCuisineFilterPresented) {
                CuisineMultiSelectView(
                    availableCuisines: availableCuisines,
                    selectedCuisines: $selectedCuisines
                )
            }
        }
    }
}

// MARK: - Multi-Select Cuisine Filter View
struct CuisineMultiSelectView: View {
    let availableCuisines: [String]
    @Binding var selectedCuisines: Set<String>
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(availableCuisines, id: \.self) { cuisine in
                    HStack {
                        Text(cuisine)
                        Spacer()
                        if selectedCuisines.contains(cuisine) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }
                    }
                    .contentShape(Rectangle()) // Makes the whole row tappable
                    .onTapGesture {
                        if selectedCuisines.contains(cuisine) {
                            selectedCuisines.remove(cuisine)
                        } else {
                            selectedCuisines.insert(cuisine)
                        }
                    }
                }
            }
            .navigationTitle("Filter by Cuisine")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        selectedCuisines.removeAll()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

