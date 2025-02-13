//
//  ContentView.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//


// Unit testing
// Caching
// Documentation
// Readme
// Video

// Deploy on app store

import SwiftUI


struct ContentView: View {
    var body: some View {
        RecipeMainView()
    }
}


// Add this ShareSheet struct to handle sharing
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}


#Preview {
    ContentView()
}
