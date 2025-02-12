//
//  AskAIModalView.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//


import SwiftUI
import Lottie

struct AskAIModalView: View {
    let recipe: Recipe
    @State private var userQuestion: String = ""
    @State private var aiResponse: String = ""
    @State private var isQuestionSent: Bool = false
    @State private var isLoading: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    private let gradientColors = [Color.accentColor, Color.accentColor.opacity(0.7)]

    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Navigation Bar
            ZStack {
                LinearGradient(gradient: Gradient(colors: gradientColors),
                             startPoint: .leading,
                             endPoint: .trailing)
                
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                            .padding(8)
                            .background(Color.black.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Text("AI Recipe Assistant")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.vertical, 12)
            }
            .frame(height: 56)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Recipe Context Card
                    recipeContextCard
                        .padding(.top)
                    
                    if !isQuestionSent {
                        questionInputSection
                    }
                    
                    if isLoading {
                        loadingSection
                    }
                    
                    if !aiResponse.isEmpty {
                        responseSection
                    }
                }
                .padding()
            }
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.top)
    }
    
    private var recipeContextCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About: \(recipe.name)")
                .font(.headline)
            Text("Feel free to ask any questions about ingredients, cooking steps, or modifications!")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
    
    private var questionInputSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                TextField("Ask about ingredients, steps, or modifications...", text: $userQuestion)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
                
                Button(action: {
                    isLoading = true
                    Task {
                        await askAI(question: userQuestion, recipe: recipe)
                    }
                    isQuestionSent = true
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(userQuestion.isEmpty ? .gray : .accentColor)
                        .background(Circle().fill(Color(UIColor.secondarySystemBackground)))
                }
                .disabled(userQuestion.isEmpty)
            }
            
            
            
            
            // Suggestion Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["Ingredients?", "Cook time?", "Tips?"], id: \.self) { suggestion in
                        Button(action: { userQuestion = suggestion }) {
                            Text(suggestion)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(20)
                                .bold()
                        }
                    }
                }
            }
        }
    }
    
    private var loadingSection: some View {
        VStack {
            LottieView(animation: .named("Animation"))
                .playing(loopMode: .loop)
                .frame(width: 200, height: 200)
            Text("Analyzing recipe...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var responseSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.blue)
                Text("AI Response")
                    .font(.headline)
            }
            
            Text(aiResponse)
                .font(.body)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.secondarySystemBackground))
                )
            
            Button(action: {
                isQuestionSent = false
                aiResponse = ""
                userQuestion = ""
            }) {
                Label("Ask Another Question", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(gradient: Gradient(colors: gradientColors),
                                     startPoint: .leading,
                                     endPoint: .trailing)
                            .cornerRadius(12)
                    )
            }
        }
    }
    
    private func askAI(question: String, recipe: Recipe) async {
        let geminiService = GeminiService()
        do {
            let response = try await geminiService.generateAIResponse(userQuestion: question, recipe: recipe)
            aiResponse = response
        } catch {
            aiResponse = "Sorry, I couldn't process your question. Please try again."
            print("Error fetching AI response: \(error.localizedDescription)")
        }
        isLoading = false
    }
}

