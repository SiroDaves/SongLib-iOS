//
//  Listing.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import Foundation

struct Listing: Identifiable, Codable, Equatable {
    var id: UUID
    let parentId: UUID
    let songId: Int
    let title: String
    let createdAt: Date
    let updatedAt: Date
}
