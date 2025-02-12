//
//  GeminiService.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
// AIzaSyBiGXVSCGGyNUUo5f8c60Pe7UCgsqzBxME

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

class GeminiService {
    private var apiKey: String?
    
    private func fetchAPIKey() {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "Gemini_api_key") as? String {
            self.apiKey = apiKey
        } else {
            print("API Key not found!")
        }
    }
    
    func generateAIResponse(userQuestion: String, recipe: Recipe) async throws -> String {
        fetchAPIKey()
        
        guard let apiKey = self.apiKey else {
            throw NSError(domain: "GeminiService", code: 1, userInfo: [NSLocalizedDescriptionKey: "API key is missing."])
        }

        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)")!
        
        let requestPayload = GeminiRequest(
            contents: [
                GeminiRequest.Content(parts: [
                    GeminiRequest.Content.Text(text: userQuestion),
                    GeminiRequest.Content.Text(text: recipeDescription(recipe))
                ])
            ],
            generationConfig: GeminiRequest.GenerationConfig(
                temperature: 0.7,
                topK: 40,
                topP: 0.8,
                maxOutputTokens: 150
            )
        )
        
        let jsonData = try JSONEncoder().encode(requestPayload)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("text/plain", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
        
        guard let rawResponse = response.candidates.first?.content.parts.first?.text else {
            return "No response found."
        }
        
        return cleanResponse(rawResponse)
    }

    private func recipeDescription(_ recipe: Recipe) -> String {
        """
        Context: This is about Recipe: \(recipe.name) (\(recipe.cuisine) cuisine).
        
        Instructions for response:
        1. Respond in simple plain text only
        2. Do not use any formatting or special characters
        3. Keep response under 150 words
        4. Use natural, conversational language
        5. Avoid bullet points, numbering, or any markdown
        6. Focus on direct, clear answers
        7. If listing items, use commas and natural language
        
        Question:
        """
    }
    
    private func cleanResponse(_ response: String) -> String {
        var cleaned = response
            .replacingOccurrences(of: "•", with: "")
            .replacingOccurrences(of: "*", with: "")
            .replacingOccurrences(of: "#", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "`", with: "")
            .replacingOccurrences(of: "_", with: "")
            
        // Remove any markdown-style links
        cleaned = cleaned.replacingOccurrences(
            of: "\\[([^\\]]+)\\]\\([^)]+\\)",
            with: "$1",
            options: .regularExpression
        )
        
        // Remove multiple newlines
        cleaned = cleaned.replacingOccurrences(
            of: "\n+",
            with: "\n",
            options: .regularExpression
        )
        
        // Remove any remaining markdown or special formatting
        cleaned = cleaned.replacingOccurrences(
            of: "[\\[\\]\\|\\>]",
            with: "",
            options: .regularExpression
        )
        
        // Trim extra whitespace
        cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return cleaned
    }
}
