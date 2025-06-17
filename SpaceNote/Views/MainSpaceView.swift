//
//  MainSpaceView.swift
//  SpaceNote
//
//  Created by yunsly on 6/17/25.
//

import SwiftUI

struct MainSpaceView: View {
    // 네비게이션 로직 관리
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            ZStack {
                Image("SpaceBackground")
                    .resizable(resizingMode: .tile)
                    .ignoresSafeArea()
                
            }
            
        }
    }
    
}

#Preview {
    MainSpaceView()
        .environmentObject(NavigationManager())
}
