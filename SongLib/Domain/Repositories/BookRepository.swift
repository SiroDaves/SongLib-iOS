//
//  BookRepository.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import Foundation

protocol BookRepositoryProtocol {
    func fetchBooks() async throws -> BookResponse
//    func getLocalBooks() -> [Book]
//    func saveBooks(_ books: [Book])
}

class BookRepository: BookRepositoryProtocol {
    private let apiService: ApiServiceProtocol
    private let dataManager: CoreDataManager
    
    init(apiService: ApiServiceProtocol, dataManager: CoreDataManager) {
        self.apiService = apiService
        self.dataManager = dataManager
    }
    
    func fetchBooks() async throws -> BookResponse {
        return try await apiService.fetch(endpoint: .books)
    }
    
//    func getLocalBooks() -> [Book] {
//        return persistence.fetchBooks()
//    }
//    
//    func saveBooks(_ books: [Book]) {
//        persistence.saveBooks(books)
//    }
}
