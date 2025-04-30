//
//  SelectionService.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//


protocol SelectionService {
    var items: [Book] { get }
    var addedBook: Book? { get }
    func addBook(_ book: Book)
}

final class SelectionManager: SelectionService {
    private(set) var books: [Book] = []
    private(set) var addedBook: Book? = nil
    
    func addBook(_ book: Book) {
        items.append(book)
        addedBook = book
    }
}
