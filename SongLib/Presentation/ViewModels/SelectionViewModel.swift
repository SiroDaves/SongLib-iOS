//
//  SelectionViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import Foundation
import Combine

class SelectionViewModel {
    private let bookRepository: BookRepositoryProtocol
    private let songRepository: SongRepositoryProtocol
    private let appPreferences: AppPreferences
    
    @Published var books: [Book] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var isSyncComplete = false
    
    init(bookRepository: BookRepositoryProtocol, songRepository: SongRepositoryProtocol, appPreferences: AppPreferences) {
        self.bookRepository = bookRepository
        self.songRepository = songRepository
        self.appPreferences = appPreferences
    }
    
    func loadBooks() {
        isLoading = true
        
        Task {
            do {
                let fetchedBooks = try await bookRepository.fetchBooks()
                
                await MainActor.run {
                    self.books = fetchedBooks
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    func selectBooks(_ selectedBooks: [Book]) {
        guard !selectedBooks.isEmpty else { return }
        
        isLoading = true
        
        Task {
            do {
                // Save selected books to CoreData
                self.bookRepository.saveBooks(selectedBooks)
                
                // For each book, fetch its songs and save them
                for book in selectedBooks {
                    let songs = try await self.songRepository.fetchSongs(for: book.id)
                    self.songRepository.saveSongs(songs, for: book.id)
                }
                
                // Mark data as downloaded in preferences
                await MainActor.run {
                    self.appPreferences.isDataDownloaded = true
                    self.isLoading = false
                    self.isSyncComplete = true
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
}
