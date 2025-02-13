//
//  ReicpeFilterViewModel.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/13/25.
//

import SwiftUI

// MARK: - Recipe Filter ViewModel
class RecipeFilterViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var selectedSortOption: RecipeSortOption = .nameAZ
    @Published var searchText: String = ""
    @Published var selectedCuisines: Set<String> = []
    
    var sortedRecipes: [Recipe] {
        let sorted = switch selectedSortOption {
        case .nameAZ:
            recipes.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .nameZA:
            recipes.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        case .cuisineAZ:
            recipes.sorted { $0.cuisine.localizedCaseInsensitiveCompare($1.cuisine) == .orderedAscending }
        case .cuisineZA:
            recipes.sorted { $0.cuisine.localizedCaseInsensitiveCompare($1.cuisine) == .orderedDescending }
        }
        return sorted
    }
    
    var filteredRecipes: [Recipe] {
        sortedRecipes.filter { recipe in
            let matchesSearch = searchText.isEmpty ||
            recipe.name.localizedCaseInsensitiveContains(searchText) ||
            recipe.cuisine.localizedCaseInsensitiveContains(searchText)
            
            let matchesCuisine = selectedCuisines.isEmpty || selectedCuisines.contains(recipe.cuisine)
            
            return matchesSearch && matchesCuisine
        }
    }
    
    var availableCuisines: [String] {
        let cuisines = Set(recipes.map { $0.cuisine })
        return Array(cuisines).sorted()
    }
    
    func updateRecipes(_ newRecipes: [Recipe]) {
        recipes = newRecipes
    }
}
