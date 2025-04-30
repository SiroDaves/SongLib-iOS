//
//  BookDetailViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

final class BookDetailViewModel: ObservableObject {
    @Published var book: Book
    private let selectionManager: SelectionService
    private let analyticsService: AnalyticsServiceProtocol
    private let networkService: NetworkServiceProtocol
    
    init(book: Book, selectionManager: SelectionService, analyticsService: AnalyticsServiceProtocol, networkService: NetworkServiceProtocol) {
        self.book = book
        self.selectionManager = selectionManager
        self.analyticsService = analyticsService
        self.networkService = networkService
    }
    
    func addToCart() {
        selectionManager.addBook(book)
        analyticsService.trackEvent("Added \(book.title) to cart")
    }
    
    func fetchBookDetails() async {
        let books = await networkService.fetchBooks()
        print("Fetched books: \(book)")
    }
}
