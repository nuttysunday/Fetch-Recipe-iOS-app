//
//  AIModel.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/13/25.
//

import Foundation

struct GeminiRequest: Codable {
    let contents: [Content]
    let generationConfig: GenerationConfig
    
    struct Content: Codable {
        let parts: [Text]
        
        struct Text: Codable {
            let text: String
        }
    }
    
    struct GenerationConfig: Codable {
        let temperature: Float
        let topK: Int
        let topP: Float
        let maxOutputTokens: Int
    }
}

struct GeminiResponse: Codable {
    let candidates: [Candidate]
    
    struct Candidate: Codable {
        let content: Content
        
        struct Content: Codable {
            let parts: [Part]
            
            struct Part: Codable {
                let text: String
            }
        }
    }
}
