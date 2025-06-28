//
//  CGPointExtension.swift
//  SpaceNote
//
//  Created by yunsly on 6/24/25.
//

import Foundation

extension CGPoint {
    func applying(scale: CGFloat, offset: CGSize) -> CGPoint {
        CGPoint(
            x: self.x * scale + offset.width,
            y: self.y * scale + offset.height
        )
    }
}
