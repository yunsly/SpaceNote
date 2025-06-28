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
    
    // 위치 정보
    var position: CGPoint {
        get { CGPoint(x: x, y: y) }
        set {
            x = newValue.x
            y = newValue.y
        }
    }
    
    // 타이틀 및 내용
    var title: String
    var content: String
    
    // 소속된 별자리
    var constellationID: UUID?
    
    init(id: UUID = UUID(), position: CGPoint, constellationID: UUID? = nil, title: String, content: String) {
        self.id = id
        self.x = position.x
        self.y = position.y
        self.constellationID = constellationID
        self.title = title
        self.content = content
    }
}
