//
//  SongView.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import Foundation

struct SongView: Identifiable, Codable, Equatable {
    var id: Int
    let song: Int
    let created: Date
}
