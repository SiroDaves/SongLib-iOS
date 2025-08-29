//
//  MockSongBookRepository.swift
//  SongLib
//
//  Created by Siro Daves on 28/08/2025.
//

import Foundation

class MockSongBookRepository: SongBookRepositoryProtocol {
    var mockBooks: [Book] = Book.sampleBooks
    var mockSongs: [Song] = Song.sampleSongs
    var shouldThrowError = false
    
    func fetchRemoteBooks() async throws -> BookResponse {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return BookResponse(count: 2, data: mockBooks)
    }
    
    func fetchRemoteSongs(for bookId: String) async throws -> SongResponse {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return SongResponse(count: 1, data: mockSongs)
    }
    
    func fetchLocalBooks() -> [Book] {
        return mockBooks
    }
    
    func fetchLocalSongs() -> [Song] {
        return mockSongs
    }
    
    func saveBooks(_ books: [Book]) {
        self.mockBooks.append(contentsOf: books)
    }
    
    func saveSong(_ song: Song) {
        self.mockSongs.append(song)
    }
    
    func likeSong(_ song: Song) {
        
    }
    
    func deleteLocalData() {
        mockBooks.removeAll()
        mockSongs.removeAll()
    }
}
