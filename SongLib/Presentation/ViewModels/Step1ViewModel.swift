//
//  Step1ViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

class Step1ViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    func fetchBooks() {
        isLoading = true
        errorMessage = nil

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.books = (1...10).map { Book(id: $0, title: "Book \($0)") }
            self.isLoading = false
        }
    }

    func toggleSelection(for book: Book) {
        if let index = books.firstIndex(of: book) {
            books[index].isSelected.toggle()
        }
    }

    func selectedBooks() -> [Book] {
        books.filter { $0.isSelected }
    }

    func saveBooks() {
        // Handle persistence here
        print("Saved books: \(selectedBooks().map { $0.title })")
    }
}
