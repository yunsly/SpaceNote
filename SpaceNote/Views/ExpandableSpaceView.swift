//
//  ExpandableSpaceView.swift
//  SpaceNote
//
//  Created by yunsly on 6/24/25.
//

// ✅ ExpandableSpaceView.swift (리팩토링 버전)
// - 화면 이동은 배경 뷰에만 제스처 적용
// - isSpaceDraggingEnabled 삭제
// - 구조적으로 책임 분산
// - ⭐️ onStarTap 콜백 추가하여 별 선택 시 외부 처리 가능

import SwiftUI

struct ExpandableSpaceView: View {
    @ObservedObject var viewModel: StarPointViewModel
    @Binding var scale: CGFloat
    @Binding var offset: CGSize
    @Binding var isConnecting: Bool

    @State private var lastScale: CGFloat = 1.0
    @State private var lastOffset: CGSize = .zero

    @State private var isTouchNearStar: Bool = false

    let tileImageName = "SpaceBackground"
    let tileSize: CGFloat = 256

    // ✅ 외부에서 별 탭 처리할 수 있도록 콜백 추가
    var onStarTap: (StarPoint) -> Void = { _ in }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 🌌 무한 타일 배경 → ✅ 화면 이동 제스처는 여기에만 적용
                InfiniteTiledBackground(
                    image: Image(tileImageName),
                    tileSize: tileSize,
                    scale: scale,
                    offset: offset
                )
                .gesture( // ✅ 화면 이동 전용 제스처
                    isConnecting ? nil :
                    DragGesture()
                        .onChanged { value in
                            offset = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        }
                )

                // 🌟 별 & 연결선
                ConstellationView(
                    viewModel: viewModel,
                    scale: scale,
                    offset: offset,
                    isTouchNearStar: $isTouchNearStar,
                    isConnecting: $isConnecting,
                    onStarTap: onStarTap // ✅ 전달
                )
            }
            .gesture( // ✅ 확대/축소는 전체에 적용
                isConnecting ? nil :
                MagnificationGesture()
                    .onChanged { value in
                        let newScale = min(max(lastScale * value, 0.5), 4.0)

                        let anchor = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        let spaceX = (anchor.x - offset.width) / scale
                        let spaceY = (anchor.y - offset.height) / scale

                        scale = newScale

                        offset = CGSize(
                            width: anchor.x - spaceX * scale,
                            height: anchor.y - spaceY * scale
                        )
                    }
                    .onEnded { _ in
                        lastScale = scale
                        lastOffset = offset
                    }
            )
        }
    }
}
