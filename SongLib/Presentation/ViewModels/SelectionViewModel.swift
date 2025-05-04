//
//  Step1ViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation
import SwiftUI

final class SelectionViewModel: ObservableObject {
    @Published var books: [Selectable<Book>] = []
    @Published var songs: [Song] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var errorMessage: String? = nil

    private let prefsRepo: PrefsRepository
    private let bookRepo: BookRepositoryProtocol
    private let songRepo: SongRepositoryProtocol

    init(prefsRepo: PrefsRepository, bookRepo: BookRepositoryProtocol, songRepo: SongRepositoryProtocol) {
        self.prefsRepo = prefsRepo
        self.bookRepo = bookRepo
        self.songRepo = songRepo
    }
    
    func toggleSelection(for book: Book) {
        guard let index = books.firstIndex(where: { $0.data.id == book.id }) else { return }
        books[index].isSelected.toggle()
    }

    func selectedBooks() -> [Book] {
        books.filter { $0.isSelected }.map { $0.data }
    }

    func selectedBooksIds() -> String {
        books
            .filter { $0.isSelected }
            .map { "\($0.data.bookNo)" }
            .joined(separator: ",")
    }

    func fetchBooks() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let resp: BookResponse = try await bookRepo.fetchRemoteBooks()
                let data = resp.data.map { Selectable(data: $0, isSelected: false) }
                await MainActor.run {
                    self.books = data
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to fetch books: \(error)"
                    self.isLoading = false
                }
            }
        }
    }

    func saveBooks() {
        isLoading = true
        print("Selected books: \(selectedBooks())")
                
        Task {
            self.bookRepo.saveBooksLocally(selectedBooks())
            
            await MainActor.run {
                self.prefsRepo.isDataSelected = true
                self.prefsRepo.selectedBooks = selectedBooksIds()
                self.isLoading = false
            }
        }
    }
    
    func fetchSongs() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let resp: SongResponse = try await songRepo.fetchRemoteSongs(for: prefsRepo.selectedBooks)
                await MainActor.run {
                    self.songs = resp.data
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to fetch songs: \(error)"
                    self.isLoading = false
                }
            }
        }
    }

    func saveSongs() {
        isLoading = true
                
        Task {
            self.songRepo.saveSongsLocally(songs)
            
            await MainActor.run {
                self.prefsRepo.isDataLoaded = true
                self.isLoading = false
            }
        }
    }
}
