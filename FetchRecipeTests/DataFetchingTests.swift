//
//  Test.swift
//  FetchRecipeTests
//
//  Created by Shivam Ghodke on 2/13/25.
//

import Testing
import Foundation
@testable import FetchRecipe

struct RecipeFetcherTests {
    
    // Test 1: Successful fetch of recipes
    @Test func testFetchRecipesSuccess() async throws {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let decodedResponse = try decoder.decode(RecipeList.self, from: data)
        
        #expect(!decodedResponse.recipes.isEmpty, "Recipes list should not be empty")
    }
    
    // Test 2: Check valid HTTP status code (200 OK)
    @Test func testFetchRecipesStatusCode() async throws {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse {
            #expect(httpResponse.statusCode == 200, "Expected status code 200, but got \(httpResponse.statusCode)")
        }
    }
    
    // Test 3: Check JSON decoding from the fetched data
    @Test func testFetchRecipesDecoding() async throws {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let decodedResponse = try decoder.decode(RecipeList.self, from: data)
        
        #expect(!decodedResponse.recipes.isEmpty, "Recipes list should not be empty")
    }
    
    // Test 4: Handle malformed data gracefully
    @Test func testFetchRecipesMalformedData() async throws {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let _ = try decoder.decode(RecipeList.self, from: data)
            #expect(false, "Expected failure due to malformed data, but succeeded in decoding")
        } catch {
            // Expected failure due to malformed JSON
            #expect(true, "Caught expected error: \(error.localizedDescription)")
        }
    }
    
    // Test 5: Handle empty data response
    @Test func testFetchRecipesEmptyData() async throws {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let decodedResponse = try decoder.decode(RecipeList.self, from: data)
        
        #expect(decodedResponse.recipes.isEmpty, "Recipes list should be empty")
    }
}
