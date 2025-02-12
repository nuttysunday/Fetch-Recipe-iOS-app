//
//  HandoffViewModifier.swift.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/12/25.
//

import Foundation
import SwiftUI

struct HandoffViewModifier: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase
    
    func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { oldPhase, newPhase in
                switch newPhase {
                case .active:
                    HandoffManager.shared.startHandoff()
                default:
                    break
                }
            }
            .onContinueUserActivity("com.fetchrecipe.handoff") { userActivity in
                // Handle incoming activity
                print("Continuing activity from other device")
                // Add your state restoration logic here
            }
    }
}

extension View {
    func handoffSession() -> some View {
        modifier(HandoffViewModifier())
    }
}

