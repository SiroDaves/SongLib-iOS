//
//  SongListItem.swift
//  SongLib
//
//  Created by Siro Daves on 30/08/2025.
//

import Foundation

struct SongListItem: Identifiable, Equatable {
    let id: Int
    var parent: Int
    var song: Int
    var created: Date
    var modified: Date
    
    var lastUpdate: String {
        let interval = Date().timeIntervalSince(modified)

        if interval < 60 {
            return "just now"
        } else if interval < 3600 {
            return "\(Int(interval / 60)) min ago"
        } else if interval < 86400 {
            return "\(Int(interval / 3600)) hr ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: modified)
        }
    }
}
