//
//  AppDelegate.swift
//  FetchRecipe
//
//  Created by Shivam Ghodke on 2/12/25.
//

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
