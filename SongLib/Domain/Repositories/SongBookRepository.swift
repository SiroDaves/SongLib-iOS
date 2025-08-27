//
//  SongBookRepository.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol SongBookRepositoryProtocol {
    func fetchRemoteBooks() async throws -> BookResponse
    func fetchRemoteSongs(for bookId: String) async throws -> SongResponse
    func fetchLocalBooks() -> [Book]
    func fetchLocalSongs() -> [Song]
    func fetchListings() -> [Listing]
    func saveBooks(_ books: [Book])
    func saveSong(_ song: Song)
    func saveListing(_ listing: Listing)
    func updateSong(_ song: Song)
    func updateListing(_ listing: Listing)
    func deleteListing(withId id: UUID)
    func deleteLocalData()
}

class SongBookRepository: SongBookRepositoryProtocol {
    private let apiService: ApiServiceProtocol
    private let bookData: BookDataManager
    private let songData: SongDataManager
    private let listData: ListingDataManager
    
    init(
        apiService: ApiServiceProtocol,
        bookData: BookDataManager,
        songData: SongDataManager,
        listData: ListingDataManager,
    ) {
        self.apiService = apiService
        self.bookData = bookData
        self.songData = songData
        self.listData = listData
    }
    
    func fetchRemoteBooks() async throws -> BookResponse {
        return try await apiService.fetch(endpoint: .books)
    }
    
    func fetchRemoteSongs(for booksIds: String) async throws -> SongResponse {
        return try await apiService.fetch(endpoint: .songsByBook(booksIds))
    }
    
    func fetchLocalBooks() -> [Book] {
        let books = bookData.fetchBooks()
        return books.sorted { $0.bookId < $1.bookId }
    }
    
    func fetchLocalSongs() -> [Song] {
        let songs = songData.fetchSongs()
        return songs.sorted { $0.songId < $1.songId }
    }
    
    func fetchListings() -> [Listing] {
        let listings = listData.fetchListings()
        return listings.sorted { $0.createdAt < $1.createdAt }
    }
    
    func saveBooks(_ books: [Book]) {
        bookData.saveBooks(books)
    }
    
    func saveSong(_ song: Song) {
        songData.saveSong(song)
    }
    
    func saveListing(_ listing: Listing) {
        listData.saveListing(listing)
    }
    
    func updateSong(_ song: Song) {
        songData.updateSong(song)
    }
    
    func updateListing(_ listing: Listing) {
        listData.updateListing(listing)
    }
    
    func deleteListing(withId id: UUID) {
        listData.deleteListing(withId: id)
    }
    
    func deleteLocalData() {
        bookData.deleteAllBooks()
        songData.deleteAllSongs()
        listData.deleteAllListings()
    }
    
}
