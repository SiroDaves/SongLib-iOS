//
//  SongRepository.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import Foundation

protocol SongRepositoryProtocol {
    func fetchSongs(for bookId: String) async throws -> [Song]
    func getLocalSongs(for bookId: String?) -> [Song]
    func saveSongs(_ songs: [Song], for bookId: String)
}

class SongRepository: SongRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let coreDataManager: CoreDataManager
    
    init(networkService: NetworkServiceProtocol, coreDataManager: CoreDataManager) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
    }
    
    func fetchSongs(for bookId: String) async throws -> [Song] {
        return try await networkService.fetch(endpoint: .songsForBook(bookId))
    }
    
    func getLocalSongs(for bookId: String? = nil) -> [Song] {
        return coreDataManager.fetchSongs(for: bookId)
    }
    
    func saveSongs(_ songs: [Song], for bookId: String) {
        coreDataManager.saveSongs(songs, for: bookId)
    }
}
