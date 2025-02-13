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

// MARK: - Recipe Model
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
