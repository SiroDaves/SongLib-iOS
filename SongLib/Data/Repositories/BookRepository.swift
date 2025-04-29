//
//  BookRepository.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import Foundation

protocol BookRepositoryProtocol {
    func fetchBooks() async throws -> [Book]
    func getLocalBooks() -> [Book]
    func saveBooks(_ books: [Book])
}

class BookRepository: BookRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let coreDataManager: CoreDataManager
    
    init(networkService: NetworkServiceProtocol, coreDataManager: CoreDataManager) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
    }
    
    func fetchBooks() async throws -> [Book] {
        return try await networkService.fetch(endpoint: .books)
    }
    
    func getLocalBooks() -> [Book] {
        return coreDataManager.fetchBooks()
    }
    
    func saveBooks(_ books: [Book]) {
        coreDataManager.saveBooks(books)
    }
}
