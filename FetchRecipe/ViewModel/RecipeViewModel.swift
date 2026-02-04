
// Responsiblity  of this file is to fetch data from the external API endpoint
// And populate the Recipe Model and Recipe List Model


import Foundation
import Combine

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    
    func fetchRecipes(from urlString: String = "https://shivam.foo/api/recipes.json") async {
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
