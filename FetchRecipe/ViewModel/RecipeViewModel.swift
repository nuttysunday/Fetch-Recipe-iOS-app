//
//  ViewModel.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//

// Contains the business logic
// Responsiblity is to fetch data from the external API endpoint



import Foundation
import Combine

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    
    func fetchRecipes(from urlString: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") async {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(RecipeList.self, from: data)
            recipes = response.recipes
        } catch {
            errorMessage = "Failed to load recipes: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
