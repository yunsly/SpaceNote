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
    
    // 별 조작
    @State private var selectedStar: StarPoint? = nil
    @State private var isShowingStarDetail = false
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            GeometryReader { geometry in
                ZStack {
                    Image("SpaceBackground")
                        .resizable(resizingMode: .tile)
                        .ignoresSafeArea()
                    
                    ForEach(viewModel.stars) { star in
                        GlowingStar(
                            position: star.position,
                            onTap: {
                                selectedStar = star
                                isShowingStarDetail = true
                            },
                            onMove: { newPosition in
                                viewModel.updatePosition(for: star, to: newPosition)
                                
                            }
                        )
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
                .sheet(isPresented: $isShowingStarDetail) {
                    if let selected = selectedStar {
                        VStack {
                            Text("⭐️ 별 메모 보기")
                                .font(.title2)
                                .padding()
                            
                            Text("ID: \(selected.id.uuidString)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            Button("닫기") {
                                isShowingStarDetail = false
                            }
                            .padding()
                        }
                        .presentationDetents([.fraction(0.3)])
                    }
                }
            }
            
        }
    }
    
}


