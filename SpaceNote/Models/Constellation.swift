//
//  Constellation.swift
//  SpaceNote
//
//  Created by yunsly on 6/18/25.
//

import SwiftData
import Foundation

@Model
final class Constellation: Identifiable {
    var id: UUID
    var name: String?

    init(id: UUID = UUID(), name: String? = nil) {
        self.id = id
        self.name = name
    }
}
