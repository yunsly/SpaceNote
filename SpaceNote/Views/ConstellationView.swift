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

struct ConstellationView: View {
    @ObservedObject var viewModel: StarPointViewModel
    let scale: CGFloat
    let offset: CGSize
    @Binding var isTouchNearStar: Bool

    // ⭐️ 외부에서 별 탭 처리할 수 있도록 콜백 추가
    var onStarTap: (StarPoint) -> Void = { _ in }

    var body: some View {
        ZStack {
            // 🌌 별자리 연결선
            ForEach(viewModel.connections) { connection in
                if let from = viewModel.stars.first(where: { $0.id == connection.fromStarID }),
                   let to = viewModel.stars.first(where: { $0.id == connection.toStarID }) {
                    let fromPos = from.position.applying(scale: scale, offset: offset)
                    let toPos = to.position.applying(scale: scale, offset: offset)

                    Path { path in
                        path.move(to: fromPos)
                        path.addLine(to: toPos)
                    }
                    .stroke(Color.white.opacity(0.4), lineWidth: 1.5)
                }
            }

            // ⭐️ 별
            ForEach(viewModel.stars) { star in
                let position = star.position.applying(scale: scale, offset: offset)

                GlowingStar(
                    position: position,
                    scale: scale,
                    onTap: {
                        onStarTap(star) // ✅ 외부로 전달
                    },
                    onMove: { newPos in
                        // 별 이동 처리: 우주 좌표로 환산 후 업데이트
                        let spaceX = (newPos.x - offset.width) / scale
                        let spaceY = (newPos.y - offset.height) / scale
                        viewModel.updatePosition(for: star, to: CGPoint(x: spaceX, y: spaceY))
                    },
                    onDragChanged: { _ in },
                    isConnectModeEnabled: false
                )
            }
        }
    }

    // 🔍 주변 별 감지 (별 근처에서 제스처 작동 판단용)
    func checkIfNearStar(_ screenLocation: CGPoint) -> Bool {
        viewModel.stars.contains { star in
            let screenPos = star.position.applying(scale: scale, offset: offset)
            let distance = hypot(screenLocation.x - screenPos.x, screenLocation.y - screenPos.y)
            return distance < 30
        }
    }
}
