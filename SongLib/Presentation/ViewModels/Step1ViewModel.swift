//
//  Step1ViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation
import SwiftUI

struct BookResponse: Decodable {
    let count: Int
    let data: [Book]
}

final class Step1ViewModel: ObservableObject {
    @Published var books: [Selectable<Book>] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let apiService: ApiServiceProtocol

    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }

    func fetchBooks() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response: BookResponse = try await apiService.fetch(endpoint: .books)
                let bookList = response.data.map { Selectable(data: $0, isSelected: false) }
                await MainActor.run {
                    self.books = bookList
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to fetch books: \(error)"
                    //self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    func toggleSelection(for book: Book) {
        guard let index = books.firstIndex(where: { $0.data.id == book.id }) else { return }
        books[index].isSelected.toggle()
    }

    func selectedBooks() -> [Book] {
        books.filter { $0.isSelected }.map { $0.data }
    }

    func saveBooks() {
        print("Saved books: \(selectedBooks().map { $0.title })")
    }
}
