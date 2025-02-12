//
//  AskAIModalView.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//


import SwiftUI

struct AskAIModalView: View {
    let recipe: Recipe  // Accept recipe as a parameter
    @State private var userQuestion: String = ""  // Store the user's input
    @State private var aiResponse: String = ""  // Store the AI's response
    @State private var isQuestionSent: Bool = false  // To track if the question is sent
    @State private var isLoading: Bool = false  // To show loading indicator

    var body: some View {
        VStack(spacing: 16) {
            Text("Ask AI anything about the recipe!")
                .font(.title)
                .padding()

            // Show the TextField and Send button only if the question hasn't been sent
            if !isQuestionSent {
                HStack{

                    TextField("Type your question here...", text: $userQuestion )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                            // Call a function to handle the AI request here
                            isLoading = true
                            Task {
                                await askAI(question: userQuestion, recipe: recipe)  // Pass recipe to askAI function
                            }
                            isQuestionSent = true
                        }) {
                            Image(systemName: "arrow.right.circle.fill") 
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .foregroundColor(userQuestion.isEmpty ? .gray : .blue)
                        }
                        .disabled(userQuestion.isEmpty)
                }
                .frame(height : 50)
            }
            
            // Show loading indicator while waiting for the response
            if isLoading {
                ProgressView("Asking AI...")
                    .progressViewStyle(CircularProgressViewStyle())
            }

            // Display AI response (if any)
            if !aiResponse.isEmpty {
                Text(aiResponse)
                    .padding()
            }
        }
        .padding()
    }

    @Environment(\.dismiss) var dismiss  // To dismiss the modal

    // Function to call Gemini API with the user's question and recipe
    func askAI(question: String, recipe: Recipe) async {
        let geminiService = GeminiService()
        do {
            // Pass the user's question and the recipe to the Gemini API
            let response = try await geminiService.generateAIResponse(userQuestion: question, recipe: recipe)
            aiResponse = response  // Store the AI's response
        } catch {
            aiResponse = "Error: \(error.localizedDescription)"
            print("Error fetching AI response: \(error.localizedDescription)")  // Log the error for debugging
        }
        isLoading = false
    }
}
