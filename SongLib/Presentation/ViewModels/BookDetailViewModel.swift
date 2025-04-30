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
    private let apiService: ApiServiceProtocol
    
    init(book: Book, selectionManager: SelectionService, analyticsService: AnalyticsServiceProtocol, apiService: ApiServiceProtocol) {
        self.book = book
        self.selectionManager = selectionManager
        self.analyticsService = analyticsService
        self.apiService = apiService
    }
    
    func addToCart() {
        selectionManager.addBook(book)
        analyticsService.trackEvent("Added \(book.title) to cart")
    }
    
    func fetchBooks() async {
        //let books = await apiService.fetch(endpoint: .book)
        print("Fetched books: \(book)")
    }
}
