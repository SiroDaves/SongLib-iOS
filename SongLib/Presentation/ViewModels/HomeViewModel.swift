//
//  HomeViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var songs: [Song] = []
    @Published var likes: [Song] = []
    @Published var filtered: [Song] = []
    @Published var uiState: ViewUiState = .idle

    private let prefsRepo: PrefsRepository
    private let bookRepo: BookRepositoryProtocol
    private let songRepo: SongRepositoryProtocol

    init(
        prefsRepo: PrefsRepository,
        bookRepo: BookRepositoryProtocol,
        songRepo: SongRepositoryProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.bookRepo = bookRepo
        self.songRepo = songRepo
    }
    
    func fetchData() {
        uiState = .loading("Fetching data ...")

        Task {
            await MainActor.run {
                self.books = bookRepo.fetchLocalBooks()
                self.songs = songRepo.fetchLocalSongs()
                self.uiState = .fetched
            }
        }
    }
    
    func filterData(book: Int) {
        uiState = .filtering

        Task {
            await MainActor.run {
                self.filtered = songs.filter { $0.book == book }
                self.likes = songs.filter { $0.liked }
                self.uiState = .filtered
            }
        }
    }


}
