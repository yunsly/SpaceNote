//  Category.swift
//  SpaceNote
//
//  Created by yunsly on 6/28/25.
//

import Foundation
import SwiftData

@Model
final class Category: Identifiable {
    var id: UUID
    var name: String
    var color: String? // 예시: 색상, 확장 가능

    init(id: UUID = UUID(), name: String, color: String? = nil) {
        self.id = id
        self.name = name
        self.color = color
    }
}
