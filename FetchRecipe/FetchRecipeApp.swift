//
//  FetchRecipeApp.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/11/25.
//

import SwiftUI



@main
struct FetchRecipeApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .handoffSession() // Custom view modifier we'll create
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.light) // Forces light mode
        }
    }
}
