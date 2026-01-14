//
//  SavedLink.swift
//  share
//
//  Created by Jean-Philippe Deis Nuel on 14/01/2026.
//

import Foundation
import SwiftData

@Model
final class SavedLink {
    var id: UUID
    var url: URL
    var title: String?
    var tags: [String]
    var isRead: Bool
    var timestamp: Date
    
    init(url: URL, title: String? = nil, tags: [String] = [], isRead: Bool = false, timestamp: Date = Date()) {
        self.id = UUID()
        self.url = url
        self.title = title
        self.tags = tags
        self.isRead = isRead
        self.timestamp = timestamp
    }
}
