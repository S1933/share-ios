//
//  Item.swift
//  share
//
//  Created by Jean-Philippe Deis Nuel on 14/01/2026.
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
