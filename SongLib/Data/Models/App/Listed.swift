//
//  Listed.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import Foundation

struct Listed: Identifiable, Codable, Equatable {
    var id: UUID
    let parentId: UUID
    let songId: String
    let title: String
    let createdAt: Date
    let updatedAt: Date
}
