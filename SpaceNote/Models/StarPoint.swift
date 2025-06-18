//
//  StarPoint.swift
//  SpaceNote
//
//  Created by yunsly on 6/18/25.
//

import Foundation
import SwiftData

@Model
final class StarPoint: Identifiable {
    var id: UUID
    var x: Double
    var y: Double
    
    var position: CGPoint {
        get { CGPoint(x: x, y: y) }
        set {
            x = newValue.x
            y = newValue.y
        }
    }
    
    init(id: UUID = UUID(), position: CGPoint) {
        self.id = id
        self.x = position.x
        self.y = position.y
    }
}
