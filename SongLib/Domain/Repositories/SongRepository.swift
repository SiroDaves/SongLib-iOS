//
//  SongRepository.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol SongRepositoryProtocol {
//    func fetchSongs(for bookId: String) async throws -> [Song]
//    func getLocalSongs(for bookId: String?) -> [Song]
//    func saveSongs(_ songs: [Song], for bookId: String)
}

class SongRepository: SongRepositoryProtocol {
    private let apiService: ApiServiceProtocol
    private let persistence: PersistenceController
    
    init(apiService: ApiServiceProtocol, persistence: PersistenceController) {
        self.apiService = apiService
        self.persistence = persistence
    }
    
//    func fetchSongs(for bookId: String) async throws -> [Song] {
//        return try await apiService.fetch(endpoint: .songsForBook(bookId))
//    }
//    
//    func getLocalSongs(for bookId: String? = nil) -> [Song] {
//        return persistence.fetchSongs(for: bookId)
//    }
//    
//    func saveSongs(_ songs: [Song], for bookId: String) {
//        persistence.saveSongs(songs, for: bookId)
//    }
}
