//
//  ConstellationView.swift
//  SpaceNote
//
//  Created by yunsly on 6/24/25.
//

// ✅ ConstellationView.swift (리팩토링 버전)
// - 별 관련 제스처, UI 담당
// - 화면 이동 제어 제거
// - ⭐️ onStarTap 콜백으로 별 탭 시 외부 처리 가능

import SwiftUI

import SwiftUI

struct ConstellationView: View {
    @ObservedObject var viewModel: StarPointViewModel
    let scale: CGFloat
    let offset: CGSize
    @Binding var isTouchNearStar: Bool
    
    @Binding var isConnecting: Bool
    @State private var draggingStarID: UUID? = nil
    @State private var selectedStar: StarPoint? = nil
    @State private var isShowingStarDetail = false
    @State private var connectedStars: [StarPoint] = []
    @State private var currentDragPosition: CGPoint? = nil
    @State private var liveConnections: [(from: StarPoint, to: StarPoint)] = []
    @State private var tempPositions: [UUID: CGPoint] = [:]

    var onStarTap: (StarPoint) -> Void = { _ in }

    var body: some View {
        ZStack {
            // 저장된 연결선
            ForEach(viewModel.connections) { connection in
                if let from = viewModel.stars.first(where: { $0.id == connection.fromStarID }),
                   let to = viewModel.stars.first(where: { $0.id == connection.toStarID }) {

                    let fromRaw = tempPositions[connection.fromStarID] ?? from.position
                    let toRaw = tempPositions[connection.toStarID] ?? to.position

                    let fromPos = fromRaw.applying(scale: scale, offset: offset)
                    let toPos = toRaw.applying(scale: scale, offset: offset)

                    Path { path in
                        path.move(to: fromPos)
                        path.addLine(to: toPos)
                    }
                    .stroke(Color.white.opacity(0.5), lineWidth: 1.5)
                }
            }

            // 드래그 중 라이브 연결선
            ForEach(liveConnections, id: \.from.id) { pair in
                let fromPos = pair.from.position.applying(scale: scale, offset: offset)
                let toPos = pair.to.position.applying(scale: scale, offset: offset)

                Path { path in
                    path.move(to: fromPos)
                    path.addLine(to: toPos)
                }
                .stroke(Color.cyan, lineWidth: 2)
            }

            // 별 렌더링
            ForEach(viewModel.stars) { star in
                let position = star.position.applying(scale: scale, offset: offset)

                GlowingStar(
                    position: position,
                    scale: scale,
                    onTap: {
                        onStarTap(star)
                    },
                    onMove: { newPos in
                        // 화면 좌표 → 우주 좌표 변환 후 저장
                        let spaceX = (newPos.x - offset.width) / scale
                        let spaceY = (newPos.y - offset.height) / scale
                        viewModel.updatePosition(for: star, to: CGPoint(x: spaceX, y: spaceY))
                    },
                    onDragChanged: { dragPos in
                        // 🟡 기존 dragPos는 화면 좌표임 → 우주 좌표로 변환해서 저장
                        let spacePos = CGPoint(
                            x: (dragPos.x - offset.width) / scale,
                            y: (dragPos.y - offset.height) / scale
                        )
                        tempPositions[star.id] = spacePos
                        draggingStarID = star.id
                    },
                    isConnectModeEnabled: isConnecting
                )
            }

            // 현재 드래그 중 선
            if isConnecting,
               let start = connectedStars.last,
               let drag = currentDragPosition {
                let startPos = start.position.applying(scale: scale, offset: offset)

                Path { path in
                    path.move(to: startPos)
                    path.addLine(to: drag)
                }
                .stroke(Color.cyan, lineWidth: 2)
            }
        }

        .highPriorityGesture(
            isConnecting ?
            DragGesture()
                .onChanged { value in
                    currentDragPosition = value.location
                    if connectedStars.isEmpty,
                       let first = viewModel.findStar(near: value.location, scale: scale, offset: offset) {
                        connectedStars.append(first)
                        return
                    }

                    if let star = viewModel.findStar(near: value.location, scale: scale, offset: offset),
                       let last = connectedStars.last,
                       star.id != last.id,
                       (star.id == connectedStars.first?.id ||
                        !connectedStars.contains(where: { $0.id == star.id })) {
                        connectedStars.append(star)
                        liveConnections.append((from: last, to: star))
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    }
                }
                .onEnded { _ in
                    let existingConstellationID = connectedStars.compactMap { $0.constellationID }.first
                    let constellationID = existingConstellationID ?? UUID()

                    for pair in liveConnections {
                        viewModel.connectStars(start: pair.from, end: pair.to, constellationID: constellationID)
                    }
                    for star in connectedStars {
                        star.constellationID = constellationID
                    }
                    try? viewModel.modelContext.save()

                    connectedStars = []
                    liveConnections = []
                    currentDragPosition = nil
                }
            : nil
        )
    }
}
