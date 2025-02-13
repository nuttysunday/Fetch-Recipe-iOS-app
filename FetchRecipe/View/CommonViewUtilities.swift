// This file contains the code for establishing Handoff and Sharesheet
// We are not sharing any activity between devices but only letting know that app is
// being used on another device.


import Foundation
import SwiftUI

@Observable
class HandoffManager {
    static let shared = HandoffManager()
    private var activity: NSUserActivity?
    
    private init() {}
    
    func startHandoff() {
        activity = NSUserActivity(activityType: "com.fetchrecipe.handoff")
        activity?.title = "Browsing App"
        activity?.isEligibleForHandoff = true
        activity?.becomeCurrent()
    }
    
    func updateHandoffState(with userInfo: [String: Any] = [:]) {
        activity?.addUserInfoEntries(from: userInfo)
    }
}


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


// Add this ShareSheet struct to handle sharing
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
