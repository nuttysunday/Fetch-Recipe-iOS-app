//
//  APIService.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//

// Backend seperation
// Fetching data from external API


// Define Model for each recipe, that is the response we are expecting
// Define an array of recipe objects

import Foundation

// MARK: - Models
struct Recipe: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let cuisine: String
    let photoUrlLarge: URL?
    let photoUrlSmall: URL?
    let sourceUrl: URL?
    let youtubeUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case name, cuisine
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case id = "uuid"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
}

struct RecipeList: Codable {
    let recipes: [Recipe]
}


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
