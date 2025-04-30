//
//  NetworkService.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

protocol NetworkServiceProtocol {
    func fetchBooks() async -> [Book]
}

final class NetworkService: NetworkServiceProtocol {
    func fetchBooks() async -> [Book] {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return []
    }
}
