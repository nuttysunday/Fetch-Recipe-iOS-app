//
//  GeminiService.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
// AIzaSyBiGXVSCGGyNUUo5f8c60Pe7UCgsqzBxME

import Foundation

// Define a struct for the request payload
struct GeminiRequest: Codable {
    let contents: [Content]
    
    struct Content: Codable {
        let parts: [Text]
        
        struct Text: Codable {
            let text: String
        }
    }
}

// Define a struct for the response
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

class GeminiService {
    private var apiKey: String?
    
    // Function to fetch the API key
    private func fetchAPIKey() {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "Gemini_api_key") as? String {
            self.apiKey = apiKey
        } else {
            print("API Key not found!")
        }
    }
    
    // Function to generate AI response, now accepts both user question and recipe
    func generateAIResponse(userQuestion: String, recipe: Recipe) async throws -> String {
        // Fetch the API key (call the function to set it)
        fetchAPIKey()
        
        // Ensure the API key is available
        guard let apiKey = self.apiKey else {
            throw NSError(domain: "GeminiService", code: 1, userInfo: [NSLocalizedDescriptionKey: "API key is missing."])
        }

        // Build the API endpoint URL
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)")!
        
        // Prepare the request payload, including the recipe details and user question
        let requestPayload = GeminiRequest(contents: [
            GeminiRequest.Content(parts: [
                GeminiRequest.Content.Text(text: userQuestion),
                GeminiRequest.Content.Text(text: recipeDescription(recipe)) // Pass the formatted recipe description
            ])
        ])
        
        // Encode the request payload to JSON
        let jsonData = try JSONEncoder().encode(requestPayload)
        
        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("text/plain", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        // Perform the network request
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode the response data into GeminiResponse
        let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
        
        // Extract the AI's response from the candidates and return it
        return response.candidates.first?.content.parts.first?.text ?? "No response found."
    }

    // Helper function to create a description from the recipe (including name, cuisine, source, and youtube URLs)
    private func recipeDescription(_ recipe: Recipe) -> String {
        var description = "The question before this is related to Recipe Name: \(recipe.name), Cuisine: \(recipe.cuisine)"
        
        description += "Please answer in plain text and in 150 words or less."
        /*
        if let sourceUrl = recipe.sourceUrl {
            description += ", Source URL: \(sourceUrl.absoluteString)"
        }
        
        if let youtubeUrl = recipe.youtubeUrl {
            description += ", YouTube URL: \(youtubeUrl.absoluteString)"
        }
        */
        return description
    }
}
