//
//  GeminiService.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//

import Foundation

class GeminiService {
    private let apiKey = "AIzaSyBiGXVSCGGyNUUo5f8c60Pe7UCgsqzBxME"
    private let baseUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateText"

    func generateRecipeSummary(for recipe: Recipe) async throws -> String {
        let prompt = "Summarize this recipe: \(recipe.name). Ingredients: \(recipe.cuisine)."
        
        let requestBody: [String: Any] = [
            "prompt": ["text": prompt],
            "temperature": 0.7
        ]
        
        guard let url = URL(string: "\(baseUrl)?key=\(apiKey)"),
              let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
        
        return response.candidates.first?.output ?? "No summary available."
    }
}

// MARK: - API Response Model
struct GeminiResponse: Codable {
    let candidates: [GeminiCandidate]
}

struct GeminiCandidate: Codable {
    let output: String
}

