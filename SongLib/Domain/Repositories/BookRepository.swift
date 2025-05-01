//
//  BookRepository.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol BookRepositoryProtocol {
    func fetchBooks() async throws -> BookResponse
    func getLocalBooks() -> [Book]
    func saveBooks(_ books: [Book])
}

class BookRepository: BookRepositoryProtocol {
    private let apiService: ApiServiceProtocol
    private let bookData: BookDataManager
    
    init(apiService: ApiServiceProtocol, bookData: BookDataManager) {
        self.apiService = apiService
        self.bookData = bookData
    }
    
    func fetchBooks() async throws -> BookResponse {
        return try await apiService.fetch(endpoint: .books)
    }
    
    func getLocalBooks() -> [Book] {
        return bookData.fetchBooks()
    }
    
    func saveBooks(_ books: [Book]) {
        bookData.saveBooks(books)
    }
}
