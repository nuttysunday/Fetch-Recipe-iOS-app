//
//  AskAIModalView.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//


import SwiftUI
import Lottie

// MARK: - Main View
struct AskAIModalView: View {
    let recipe: Recipe
    @StateObject private var viewModel = AskAIViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(dismiss: dismiss)
            
            ScrollView {
                VStack(spacing: 20) {
                    RecipeContextCard(recipe: recipe)
                        .padding(.top)
                    
                    if !viewModel.isQuestionSent {
                        QuestionInputView(viewModel: viewModel, recipe: recipe)
                    }
                    
                    if viewModel.isLoading {
                        LoadingView()
                    }
                    
                    if !viewModel.aiResponse.isEmpty {
                        AIResponseView(viewModel: viewModel)
                    }
                }
                .padding()
            }
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.top)
    }
}


// MARK: - Custom Navigation Bar
struct CustomNavigationBar: View {
    let dismiss: DismissAction
    private let gradientColors = [Color.accentColor, Color.accentColor.opacity(0.7)]
    
    var body: some View {
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
    }
}

// MARK: - Recipe Context Card
struct RecipeContextCard: View {
    let recipe: Recipe
    
    var body: some View {
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
}

// MARK: - Question Input View
struct QuestionInputView: View {
    @ObservedObject var viewModel: AskAIViewModel
    let recipe: Recipe
    private let suggestions = ["Ingredients?", "Cook time?", "Tips?"]
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                TextField("Ask about ingredients, steps, or modifications...", text: $viewModel.userQuestion)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.secondarySystemBackground))
                    )
                
                Button {
                    Task {
                        await viewModel.askAI(question: viewModel.userQuestion, recipe: recipe)
                    }
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(viewModel.userQuestion.isEmpty ? .gray : .accentColor)
                        .background(Circle().fill(Color(UIColor.secondarySystemBackground)))
                }
                .disabled(viewModel.userQuestion.isEmpty)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(suggestions, id: \.self) { suggestion in
                        Button(action: { viewModel.userQuestion = suggestion }) {
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
}

// MARK: - AI Response View
struct AIResponseView: View {
    @ObservedObject var viewModel: AskAIViewModel
    private let gradientColors = [Color.accentColor, Color.accentColor.opacity(0.7)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.blue)
                Text("AI Response")
                    .font(.headline)
            }
            
            Text(viewModel.aiResponse)
                .font(.body)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.secondarySystemBackground))
                )
            
            Button(action: viewModel.resetState) {
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
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack {
            LottieView(animation: .named("Animation"))
                .playing(loopMode: .loop)
                .frame(width: 200, height: 200)
            Text("Analyzing recipe...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
