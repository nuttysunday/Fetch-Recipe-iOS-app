
// Loads content View and pass necessary objct
// Sets custom view modifier for Handoff on COntent
// Forces light theme

import SwiftUI

@main
struct FetchRecipeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .handoffSession()
                .preferredColorScheme(.light)
        }
    }
}
