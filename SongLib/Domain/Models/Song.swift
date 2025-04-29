//
//  Song.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

struct Song: Codable, Identifiable {
    let id: String
    let title: String
    let lyrics: String
    let bookId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case lyrics
        case bookId = "book_id"
    }
}
