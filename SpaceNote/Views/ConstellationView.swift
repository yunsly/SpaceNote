//
//  ConstellationView.swift
//  SpaceNote
//
//  Created by yunsly on 6/24/25.
//

import SwiftUI

struct ConstellationView: View {
    @ObservedObject var viewModel: StarPointViewModel
    let scale: CGFloat
    let offset: CGSize

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
                        // TODO: 선택 처리
                    },
                    onMove: { newPos in
                        let spaceX = (newPos.x - offset.width) / scale
                        let spaceY = (newPos.y - offset.height) / scale
                        viewModel.updatePosition(for: star, to: CGPoint(x: spaceX, y: spaceY))
                    },
                    onDragChanged: { dragPos in
                        // TODO: 드래그 중 처리
                    },
                    isConnectModeEnabled: false
                )
            }
        }
    }
}
