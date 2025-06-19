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

    

    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            GeometryReader { geometry in
                ZStack {
                    Image("SpaceBackground")
                        .resizable(resizingMode: .tile)
                        .ignoresSafeArea()
                    
                    // 항상 실시간 좌표를 우선 반영해서 연결선을 그림
                    ForEach(viewModel.connections) { connection in
                        if let from = viewModel.stars.first(where: { $0.id == connection.fromStarID }),
                           let to = viewModel.stars.first(where: { $0.id == connection.toStarID }) {
                            
                            // tempPositions에 있으면 그걸 먼저 사용
                            let fromPos = tempPositions[connection.fromStarID] ?? from.position
                            let toPos = tempPositions[connection.toStarID] ?? to.position

                            Path { path in
                                path.move(to: fromPos)
                                path.addLine(to: toPos)
                            }
                            .stroke(Color.white.opacity(0.5), lineWidth: 1.5)
                        }
                    }
                    
                    
                    // 별자리 라이브 연결
                    ForEach(liveConnections, id: \.from.id) { pair in
                        Path { path in
                            path.move(to: pair.from.position)
                            path.addLine(to: pair.to.position)
                        }
                        .stroke(Color.cyan, lineWidth: 2)
                    }
                    
                    // 별 렌더링
                    ForEach(viewModel.stars) { star in
                        GlowingStar(
                            position: star.position,
                            onTap: {
                                selectedStar = star
                                isShowingStarDetail = true
                            },
                            onMove: { newPosition in
                                viewModel.updatePosition(for: star, to: newPosition)
                                tempPositions[star.id] = nil
                                draggingStarID = nil
                            },
                            onDragChanged: { dragPosition in
                                tempPositions[star.id] = dragPosition
                                draggingStarID = star.id
                            },
                            isConnectModeEnabled: isConnecting
                        )
                    }
                    
                    // 연결 중인 선 그리기 (손가락 위치 따라가기)
                    if isConnecting,
                       // 손가락 위치 따라가며 연결 중인 선 그리기
                       let start = connectedStars.last,
                       let drag = currentDragPosition {
                        
                        Path { path in
                            path.move(to: start.position)
                            path.addLine(to: drag)
                        }
                        .stroke(Color.cyan, lineWidth: 2)
                    }

                    
                    // + 버튼
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
                    // 기기 흔들림 감지
                    ShakeDetector {
                        viewModel.deleteAllStars()
                    }
                    .allowsHitTesting(false)
                }
                // 연결 모드 진입 제스처
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.3)
                        .onEnded { _ in
                            isConnecting = true
                            connectedStars = []
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        }
                )
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
                            
                            // 다음 별 만났을 때 즉시 연결
                            if let star = viewModel.findStar(near: value.location),
                               let last = connectedStars.last,
                               star.id != last.id,
                               !connectedStars.contains(where: { $0.id == star.id }) {
                                
                                connectedStars.append(star)
                                liveConnections.append((from: last, to: star))
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            }
                        }
                        .onEnded { _ in
                            for pair in liveConnections {
                                viewModel.connectStars(start: pair.from, end: pair.to)
                            }
                            
                            isConnecting = false
                            connectedStars = []
                            liveConnections = []
                            currentDragPosition = nil
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
