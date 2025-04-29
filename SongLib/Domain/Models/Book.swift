//
//  Book.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

struct Book: Codable, Identifiable {
    let id: String
    let title: String
    let author: String
    let coverImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case author
        case coverImage = "cover_image"
    }
}
