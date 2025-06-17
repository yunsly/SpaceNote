//
//  Item.swift
//  SpaceNote
//
//  Created by yunsly on 6/17/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
