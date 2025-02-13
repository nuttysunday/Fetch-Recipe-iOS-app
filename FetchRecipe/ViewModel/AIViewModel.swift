//
//  AIViewModel.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/13/25.
//

import Foundation

// MARK: - ViewModel
class AskAIViewModel: ObservableObject {
    @Published var userQuestion: String = ""
    @Published var aiResponse: String = ""
    @Published var isQuestionSent: Bool = false
    @Published var isLoading: Bool = false
    
    func askAI(question: String, recipe: Recipe) async {
        isLoading = true
        let geminiService = GeminiService()
        do {
            let response = try await geminiService.generateAIResponse(userQuestion: question, recipe: recipe)
            await MainActor.run {
                aiResponse = response
                isLoading = false
            }
        } catch {
            await MainActor.run {
                aiResponse = "Sorry, I couldn't process your question. Please try again."
                isLoading = false
            }
            print("Error fetching AI response: \(error.localizedDescription)")
        }
    }
    
    func resetState() {
        isQuestionSent = false
        aiResponse = ""
        userQuestion = ""
    }
}
