//
//  SongRepository.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol SongRepositoryProtocol {
    func fetchRemoteSongs(for bookId: String) async throws -> SongResponse
    func fetchLocalSongs() -> [Song]
    func saveSongsLocally(_ songs: [Song])
}

class SongRepository: SongRepositoryProtocol {
    private let apiService: ApiServiceProtocol
    private let songData: SongDataManager
    
    init(apiService: ApiServiceProtocol, songData: SongDataManager) {
        self.apiService = apiService
        self.songData = songData
    }
    
    func fetchRemoteSongs(for booksIds: String) async throws -> SongResponse {
        return try await apiService.fetch(endpoint: .songsByBook(booksIds))
    }
    
    func fetchLocalSongs() -> [Song] {
        return songData.fetchSongs()
    }
    
    func saveSongsLocally(_ songs: [Song]) {
        songData.saveSongs(songs)
    }
}
