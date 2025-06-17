//
//  SpaceNoteApp.swift
//  SpaceNote
//
//  Created by yunsly on 6/17/25.
//

import SwiftUI
import SwiftData

@main
struct SpaceNoteApp: App {
    @StateObject private var navigationManager = NavigationManager()
    
    var body: some Scene {
        WindowGroup {
            MainSpaceView()
                .environmentObject(navigationManager)
        }
    }
}
