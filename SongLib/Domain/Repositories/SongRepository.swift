//
//  SongRepository.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol SongRepositoryProtocol {
    func fetchSongs(for bookId: String) async throws -> [Song]
    func getLocalSongs(for booksIds: Int?) -> [Song]
    func saveSongs(_ songs: [Song])
}

class SongRepository: SongRepositoryProtocol {
    private let apiService: ApiServiceProtocol
    private let songData: SongDataManager
    
    init(apiService: ApiServiceProtocol, songData: SongDataManager) {
        self.apiService = apiService
        self.songData = songData
    }
    
    func fetchSongs(for booksIds: String) async throws -> [Song] {
        return try await apiService.fetch(endpoint: .songsByBook(booksIds))
    }
    
    func getLocalSongs(for bookId: Int? = nil) -> [Song] {
        return songData.fetchSongs(for: bookId)
    }
    
    func saveSongs(_ songs: [Song]) {
        songData.saveSongs(songs)
    }
}
