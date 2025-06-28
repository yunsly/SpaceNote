//
//  InfiniteTileBackground.swift
//  SpaceNote
//
//  Created by yunsly on 6/24/25.
//

import SwiftUI

struct InfiniteTiledBackground: View {
    let image: Image
    let tileSize: CGFloat
    let scale: CGFloat
    let offset: CGSize

    var body: some View {
        GeometryReader { geometry in
            let scaledTile = tileSize * scale
            let columns = Int(geometry.size.width / scaledTile) + 3
            let rows = Int(geometry.size.height / scaledTile) + 3

            let startX = offset.width.truncatingRemainder(dividingBy: scaledTile) - scaledTile
            let startY = offset.height.truncatingRemainder(dividingBy: scaledTile) - scaledTile

            ZStack {
                ForEach(0..<rows, id: \.self) { row in
                    ForEach(0..<columns, id: \.self) { col in
                        image
                            .resizable()
                            .frame(width: scaledTile, height: scaledTile)
                            .position(
                                x: CGFloat(col) * scaledTile + startX,
                                y: CGFloat(row) * scaledTile + startY
                            )
                    }
                }
            }
        }
    }
}
