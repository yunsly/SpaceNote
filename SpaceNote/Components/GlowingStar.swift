//
//  GlowingStar.swift
//  SpaceNote
//
//  Created by yunsly on 6/18/25.
//

import SwiftUI

struct GlowingStar: View {
    @State private var isDragging = false
    @State private var dragOffset: CGSize = .zero

    var position: CGPoint
    var onMove: (CGPoint) -> Void

    var body: some View {
        Circle()
            .fill(Color.yellow)
            .frame(width: 14, height: 14)
            .shadow(color: .yellow.opacity(0.8), radius: 6)
            .position(x: position.x + dragOffset.width,
                      y: position.y + dragOffset.height)
            .gesture(
                LongPressGesture(minimumDuration: 0.3)
                    .onEnded { _ in
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        isDragging = true
                    }
                    .sequenced(before: DragGesture())
                    .onChanged { value in
                        if case .second(true, let drag?) = value {
                            dragOffset = drag.translation
                        }
                    }
                    .onEnded { value in
                        if case .second(true, let drag?) = value {
                            let newPosition = CGPoint(
                                x: position.x + drag.translation.width,
                                y: position.y + drag.translation.height
                            )
                            onMove(newPosition)
                        }
                        dragOffset = .zero
                        isDragging = false
                    }
            )
    }
}
