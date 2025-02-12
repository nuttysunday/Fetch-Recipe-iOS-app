//
//  RecipeListViewModelTests.swift
//  FetchRecipeTests
//
//  Created by Shivam Ghodke on 2/12/25.
//

import Testing
import XCTest
@testable import FetchRecipe


class RecipeListViewModelTests: XCTestCase {
    
    var sut: RecipeListViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        
        // Initialize the viewModel on the Main Actor using a Task
        Task { @MainActor in
            sut = RecipeListViewModel() // This is now executed on the main thread
        }
    }
    
    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testFetchRecipesWithInvalidURL() async {
        // Given
        let invalidURL = ""
        
        // When
        await sut.fetchRecipes(from: invalidURL)
        
        // Then: Access main actor-isolated properties within `MainActor.run`
        await MainActor.run {
            XCTAssertNotNil(sut.errorMessage)
            XCTAssertEqual(sut.errorMessage, "Invalid URL")
            XCTAssertFalse(sut.isLoading)
            XCTAssertTrue(sut.recipes.isEmpty)
        }
    }
}
