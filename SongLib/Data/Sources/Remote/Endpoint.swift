//
//  Endpoint.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

enum Endpoint {
    case books
    case songsForBook(String)
    
    var path: String {
        switch self {
        case .books:
            return "/book"
        case .songsForBook(let bookId):
            return "/songs/\(bookId)"
        }
    }
    
    var url: URL? {
        return URL(string: "https://songlive.vercel.app" + path)
    }
}
