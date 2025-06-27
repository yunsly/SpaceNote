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
    var body: some Scene {
        WindowGroup {
            AppEntryPoint()
        }
        .modelContainer(for: [StarPoint.self, StarConnection.self, Constellation.self])
    }
}

struct AppEntryPoint: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var navigationManager = NavigationManager()

    var body: some View {
        let viewModel = StarPointViewModel(modelContext: modelContext)
        MainSpaceView(viewModel: viewModel)
            .environmentObject(navigationManager)
    }
}
