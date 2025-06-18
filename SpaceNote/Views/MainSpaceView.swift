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
    @ObservedObject var viewModel: StarPointViewModel
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            GeometryReader { geometry in
                ZStack {
                    Image("SpaceBackground")
                        .resizable(resizingMode: .tile)
                        .ignoresSafeArea()
                    
                    ForEach(viewModel.stars) { star in
                        GlowingStar(position: star.position) { newPosition in
                            viewModel.updatePosition(for: star, to: newPosition)
                        }
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.addRandomStar(in: geometry.size)
                            }) {
                                Image(systemName: "plus")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Circle().fill(Color.blue))
                            }
                            .padding()
                            
                        }
                    }
                    
                    ShakeDetector {
                        viewModel.deleteAllStars()
                    }
                    .allowsHitTesting(false)
                }
            }
            
        }
    }
    
}


