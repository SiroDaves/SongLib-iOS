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
    func saveBooks(_ books: [Book])
    func saveSong(_ song: Song)
    func likeSong(_ song: Song)
    func deleteLocalData()
}

class SongBookRepository: SongBookRepositoryProtocol {
    private let apiService: ApiServiceProtocol
    private let bookData: BookDataManager
    private let songData: SongDataManager
    
    init(
        apiService: ApiServiceProtocol,
        bookData: BookDataManager,
        songData: SongDataManager,
    ) {
        self.apiService = apiService
        self.bookData = bookData
        self.songData = songData
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
    
    func saveBooks(_ books: [Book]) {
        bookData.saveBooks(books)
    }
    
    func saveSong(_ song: Song) {
        songData.saveSong(song)
    }
    
    func likeSong(_ song: Song) {
        let updatedSong = Song(
            book: song.book,
            songId: song.songId,
            songNo: song.songNo,
            title: song.title,
            alias: song.alias,
            content: song.content,
            views: song.views,
            likes: song.likes,
            liked: !song.liked,
            created: song.created
        )
        songData.updateSong(updatedSong)
    }
    
    func deleteLocalData() {
        bookData.deleteAllBooks()
        songData.deleteAllSongs()
    }
}
