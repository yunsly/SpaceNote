//
//  MainSpaceView.swift
//  SpaceNote
//
//  Created by yunsly on 6/17/25.
//

// ✅ MainSpaceView.swift (리팩토링 버전)
// - 별 선택 시 시트 연결
// - 연결 드래그 유지
// - isSpaceDraggingEnabled 제거

import SwiftUI

struct MainSpaceView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @ObservedObject var viewModel: StarPointViewModel

    // 별 메모 디테일
    @State private var selectedStar: StarPoint? = nil
    @State private var isShowingStarDetail = false

    // 연결 모드
    @State private var isConnecting = false
    @State private var connectedStars: [StarPoint] = []
    @State private var currentDragPosition: CGPoint? = nil
    @State private var liveConnections: [(from: StarPoint, to: StarPoint)] = []

    // 탭 이동 (BottomButtonBarView와 바인딩 필요)
    @State private var selectedTab: Int = 0

    // 확대/이동 상태
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero

    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            GeometryReader { geometry in
                ZStack {
                    ExpandableSpaceView(
                        viewModel: viewModel,
                        scale: $scale,
                        offset: $offset,
                        isConnecting: $isConnecting,
                        onStarTap: { star in
                            selectedStar = star
                            isShowingStarDetail = true
                        }
                    )

                    VStack {
                        BottomButtonBarView(
                            viewModel: viewModel,
                            selectedTab: $selectedTab, // ✅ 연결 모드 전환용 바인딩
                            scale: $scale,
                            offset: $offset,
                            isConnecting: $isConnecting
                        )
                    }

                    ShakeDetector {
                        viewModel.deleteAllStars()
                    }
                    .allowsHitTesting(false)
                }
                .onChange(of: selectedTab) { newValue in
                    if newValue == 1 {
                        isConnecting = true
                        connectedStars = []
                        liveConnections = []
                    } else {
                        isConnecting = false
                    }
                }
                .sheet(isPresented: $isShowingStarDetail) {
                    if let selected = selectedStar { 
                        VStack {
                            Text(selected.title)
                                .font(.title2)
                                .padding()
                            Text(selected.content)
                                .font(.title3)
                                .padding()
                            
                            Text("Star ID: \(selected.id.uuidString)").font(.caption).foregroundColor(.gray)
                            if let constellation = selected.constellationID {
                                Text("Constellation ID: \(constellation.uuidString)").font(.caption).foregroundColor(.gray)
                            }
                            Spacer()
                            Button("닫기") { isShowingStarDetail = false }.padding()
                        }
                        .presentationDetents([.fraction(0.3)])
                    }
                }
            }
        }
    }
}

