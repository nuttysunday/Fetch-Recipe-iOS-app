//
//  AIViewModel.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/13/25.
//

import Foundation


@MainActor
class AskAIViewModel: ObservableObject {
    @Published var userQuestion: String = ""
    @Published var aiResponse: String = ""
    @Published var isQuestionSent: Bool = false
    @Published var isLoading: Bool = false
    
    private let geminiService = GeminiService()
    
    func askAI(question: String, recipe: Recipe) async {
        isLoading = true
        isQuestionSent = true
        
        do {
            let response = try await geminiService.generateAIResponse(userQuestion: question, recipe: recipe)
            aiResponse = response
        } catch {
            aiResponse = "Sorry, I couldn't process your question. Please try again."
            print("Error fetching AI response: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func resetState() {
        isQuestionSent = false
        aiResponse = ""
        userQuestion = ""
    }
}
