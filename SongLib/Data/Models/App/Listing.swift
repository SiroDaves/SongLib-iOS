//
//  Listing.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import Foundation

struct Listing: Identifiable, Equatable {
    let id: UUID
    var parentId: UUID
    var songId: Int
    var title: String
    var createdAt: Date
    var updatedAt: Date
    
    var songCount: Int = 0
    var relativeUpdatedAt: String {
        let interval = Date().timeIntervalSince(updatedAt)

        if interval < 60 {
            return "just now"
        } else if interval < 3600 {
            return "\(Int(interval / 60)) min ago"
        } else if interval < 86400 {
            return "\(Int(interval / 3600)) hr ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: updatedAt)
        }
    }
}
