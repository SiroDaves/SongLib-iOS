//
//  Endpoint.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

enum Endpoint {
    case books
    case songs
    case songsByBook(String)
    
    var path: String {
        switch self {
        case .books:
            return "/book"
        case .songs:
            return "/song"
        case .songsByBook(let books):
            return "/song/book/\(books)"
        }
    }
    
    var url: URL? {
        return URL(string: "https://songlive.vercel.app/api" + path)
    }
}
