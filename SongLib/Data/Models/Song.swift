//
//  Song.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct Song: Identifiable, Codable {
    let id: Int
    let rid: Int
    let book: Int
    let songId: String
    let songNo: String
    let title: String
    let alias: String
    let content: String
    let views: Int
    let likes: Int
    let liked: Bool
    let created: String
    let updated: String
}
