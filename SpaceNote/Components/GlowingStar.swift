//
//  GlowingStar.swift
//  SpaceNote
//
//  Created by yunsly on 6/18/25.
//

import SwiftUI

struct GlowingStar: View {
    var position: CGPoint
    var scale: CGFloat
    var onTap: () -> Void
    var onMove: (CGPoint) -> Void
    var onDragChanged: ((CGPoint) -> Void)? = nil
    var isConnectModeEnabled: Bool

    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        // 별 크기 계산
        let minScale: CGFloat = 0.5
        let maxScale: CGFloat = 4.0
        let minSize: CGFloat = 10
        let maxSize: CGFloat = 28

        let normalizedScale = (scale - minScale) / (maxScale - minScale)
        let clampedRatio = min(max(normalizedScale, 0), 1)
        let starSize = minSize + (maxSize - minSize) * clampedRatio
        let hitboxSize = max(44, starSize * 2)
        let shadowRadius = starSize * 0.6

        Image("Star")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(isConnectModeEnabled ? .cyan : .yellow)
            .frame(width: starSize, height: starSize)
            .shadow(color: .yellow.opacity(0.8), radius: shadowRadius)
            .contentShape(Rectangle())
            .frame(width: hitboxSize, height: hitboxSize)
            .position(x: position.x + dragOffset.width,
                      y: position.y + dragOffset.height)

            // ⭐️ 항상 DragGesture 적용하고, 내부에서 조건 체크
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard isDragging else { return }
                        dragOffset = value.translation
                        let newPosition = CGPoint(
                            x: position.x + value.translation.width,
                            y: position.y + value.translation.height
                        )
                        onDragChanged?(newPosition)
                    }
                    .onEnded { value in
                        guard isDragging else { return }
                        let newPosition = CGPoint(
                            x: position.x + value.translation.width,
                            y: position.y + value.translation.height
                        )
                        onMove(newPosition)
                        dragOffset = .zero
                        isDragging = false
                    }
            )

            // ⭐️ 롱프레스로 이동 모드 진입 + 햅틱 발생
            .simultaneousGesture(
                LongPressGesture()
                    .onEnded { _ in
                        if !isConnectModeEnabled {
                            isDragging = true
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    }
            )

            // ⭐️ 탭 → 별 선택 (예: 시트 띄우기)
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        onTap()
                    }
            )
    }
}

