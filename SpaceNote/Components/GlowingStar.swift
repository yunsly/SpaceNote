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
    var onDragChanged: ((CGPoint) -> Void)? = nil
    var isConnectModeEnabled: Bool
    

    @State private var dragOffset: CGSize = .zero

    var body: some View {
        Circle()
            .fill(isConnectModeEnabled ? .cyan : .yellow) // 연결모드 시 색상 변경 (선택)
            .frame(width: 14, height: 14)
            .shadow(color: .yellow.opacity(0.8), radius: 6)
            .contentShape(Rectangle())
            .frame(width: 44, height: 44)
            .position(x: position.x + dragOffset.width,
                      y: position.y + dragOffset.height)
            .simultaneousGesture(
                TapGesture().onEnded { onTap() }
            )
            .gesture(
                isConnectModeEnabled ? nil :
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                        let newPosition = CGPoint(
                            x: position.x + value.translation.width,
                            y: position.y + value.translation.height
                        )
                        onDragChanged?(newPosition)
                    }
                    .onEnded { value in
                        let newPosition = CGPoint(
                            x: position.x + value.translation.width,
                            y: position.y + value.translation.height
                        )
                        onMove(newPosition)
                        dragOffset = .zero
                    }
            )
        
    }
}
