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
    
    // 별 조작 (이동 시 필요한 변수)
    @State private var draggingStarID: UUID? = nil
    
    
    // 별 메모 디테일 조작 변수
    @State private var selectedStar: StarPoint? = nil
    @State private var isShowingStarDetail = false
    
    // 별자리 연결 제어 변수
    @State private var isConnecting = false
    @State private var connectedStars: [StarPoint] = []
    @State private var currentDragPosition: CGPoint? = nil
    @State private var liveConnections: [(from: StarPoint, to: StarPoint)] = []
    @State private var tempPositions: [UUID: CGPoint] = [:]
    
    // 탭 이동
    @State private var selectedTab: Int = 0
    
    // 확장 뷰 변수
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            GeometryReader { geometry in
                ZStack {
                    // 확장 우주뷰 + 별자리 렌더링 뷰
                    ExpandableSpaceView(
                        viewModel: viewModel,
                        scale: $scale,
                        offset: $offset
                    )
                    
                    
                    // 하단부 ( + 버튼, 탭바)
                    VStack {
                        BottomButtonBarView(
                            viewModel: viewModel,
                            scale: $scale,
                            offset: $offset
                        )

                    }
                    
                    
                    
                    
                    // 기기 흔들림 감지
                    ShakeDetector {
                        viewModel.deleteAllStars()
                    }
                    .allowsHitTesting(false)
                    
                    
                }
                .onChange(of: selectedTab) { newValue in
                    if newValue == 1 {
                        // 편집 모드(연결 모드) 자동 진입
                        isConnecting = true
                        connectedStars = []
                        liveConnections = []
                    } else {
                        isConnecting = false
                    }
                }
                
                // 연결 드래그 제스처
                .gesture(
                    isConnecting
                    ? DragGesture()
                        .onChanged { value in
                            currentDragPosition = value.location
                            
                            // 시작점 지정
                            if connectedStars.isEmpty {
                                if let first = viewModel.findStar(near: value.location) {
                                    connectedStars.append(first)
                                }
                                return
                            }
                            
                            // 다음 별 만났을 때 즉시 연결 (중복 허용)
                            if let star = viewModel.findStar(near: value.location),
                               let last = connectedStars.last,
                               star.id != last.id,
                               (
                                // 처음 별은 다시 연결 허용
                                star.id == connectedStars.first?.id ||
                                // 그 외는 중복 방지
                                !connectedStars.contains(where: { $0.id == star.id })
                               )
                            {
                                connectedStars.append(star)
                                liveConnections.append((from: last, to: star))
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            }
                        }
                        .onEnded { _ in
                            // 현재 연결된 별들 중 기존 constellationID가 있는 경우 추출
                            let existingConstellationID = connectedStars
                                .compactMap { $0.constellationID }
                                .first
                            
                            // 없으면 새로 생성
                            let constellationID = existingConstellationID ?? UUID()
                            
                            // 연결 생성
                            for pair in liveConnections {
                                viewModel.connectStars(
                                    start: pair.from,
                                    end: pair.to,
                                    constellationID: constellationID
                                )
                            }
                            //                            for pair in liveConnections {
                            //                                viewModel.connectStars(start: pair.from, end: pair.to)
                            //                            }
                            
                            // 별들도 일괄적으로 같은 별자리에 포함시킴
                            for star in connectedStars {
                                star.constellationID = constellationID
                            }
                            
                            try? viewModel.modelContext.save()
                            
                            // 상태 초기화
                            isConnecting = false
                            connectedStars = []
                            liveConnections = []
                            currentDragPosition = nil
                            selectedTab = 0
                        }
                    : nil
                )
                // 메모 디테일 모달
                .sheet(isPresented: $isShowingStarDetail) {
                    if let selected = selectedStar {
                        VStack {
                            Text("⭐️")
                                .font(.title2)
                                .padding()
                            
                            Text("Star ID: \(selected.id.uuidString)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            if let constellation = selected.constellationID {
                                Text("Constellation ID: \(constellation.uuidString)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            
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

