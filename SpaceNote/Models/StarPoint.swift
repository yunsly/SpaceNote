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
    
    var title: String?
    var content: String?
    var category: Category? // 연결된 카테고리
    
    // 위치 정보
    var position: CGPoint {
        get { CGPoint(x: x, y: y) }
        set {
            x = newValue.x
            y = newValue.y
        }
    }
    
    // 소속된 별자리
    var constellationID: UUID?
    
    init(id: UUID = UUID(), position: CGPoint, constellationID: UUID? = nil, title: String? = nil, content: String? = nil, category: Category? = nil) {
        self.id = id
        self.x = position.x
        self.y = position.y
        self.constellationID = constellationID
        self.title = title
        self.content = content
        self.category = category
    }
}
