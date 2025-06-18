//
//  GlowingStar.swift
//  SpaceNote
//
//  Created by yunsly on 6/18/25.
//

import SwiftUI

struct GlowingStar: View {
    var position: CGPoint
    var onTap: () -> Void
    var onMove: (CGPoint) -> Void

    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    @State private var hasTriggeredHaptic = false

    var body: some View {
        Circle()
            .fill(Color.yellow)
            .frame(width: 14, height: 14)
            .shadow(color: .yellow.opacity(0.8), radius: 6)
            .position(x: position.x + dragOffset.width,
                      y: position.y + dragOffset.height)
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        onTap()
                    }
            )
            .gesture(
                LongPressGesture(minimumDuration: 0.1)
                    .sequenced(before: DragGesture())
                    .onChanged { value in
                        if case .second(true, let drag?) = value {
                            if !hasTriggeredHaptic {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                hasTriggeredHaptic = true
                            }
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
                        hasTriggeredHaptic = false
                    }
            )
    }
}
