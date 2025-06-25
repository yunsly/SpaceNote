//
//  ExpandableSpaceView.swift
//  SpaceNote
//
//  Created by yunsly on 6/24/25.
//

import SwiftUI


import SwiftUI

struct ExpandableSpaceView: View {
    @ObservedObject var viewModel: StarPointViewModel
    @Binding var scale: CGFloat
    @Binding var offset: CGSize
    
    // 제스처 누적값 저장
    @State private var lastScale: CGFloat = 1.0
    @State private var lastOffset: CGSize = .zero
    
    
    let tileImageName = "SpaceBackground"
    let tileSize: CGFloat = 256
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 🌌 무한 타일 배경
                InfiniteTiledBackground(
                    image: Image(tileImageName),
                    tileSize: tileSize,
                    scale: scale,
                    offset: offset
                )
                
                // 🌟 별 & 연결선
                ConstellationView(
                    viewModel: viewModel,
                    scale: scale,
                    offset: offset
                )
            }
            .gesture(
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
            .simultaneousGesture(
                // ✋ 드래그 제스처 (누적 방식)
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
        }
    }
}
