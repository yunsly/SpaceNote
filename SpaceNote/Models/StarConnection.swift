//
//  StarConnection.swift
//  SpaceNote
//
//  Created by yunsly on 6/18/25.
//

import Foundation
import SwiftData


@Model
final class StarConnection: Identifiable {
    var id: UUID
    var fromStarID: UUID
    var toStarID: UUID
    var constellationID: UUID? // 연결이 특정 별자리에 속한 경우

    init(id: UUID = UUID(), from: UUID, to: UUID, constellationID: UUID? = nil) {
        self.id = id
        self.fromStarID = from
        self.toStarID = to
        self.constellationID = constellationID
    }
}
