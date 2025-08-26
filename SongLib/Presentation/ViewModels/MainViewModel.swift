//
//  HomeViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation
import SwiftUI

final class MainViewModel: ObservableObject {
    private let prefsRepo: PrefsRepository
    private let bookRepo: BookRepositoryProtocol
    private let songRepo: SongRepositoryProtocol
    private let subsRepo: SubscriptionRepositoryProtocol
    private let reviewRepo: ReviewReqRepositoryProtocol
    
    @Published var isActiveSubscriber: Bool = false
    @Published var horizontalSlides: Bool = false
    @Published var showReviewPrompt: Bool = false
    
    @Published var books: [Book] = []
    @Published var songs: [Song] = []
    @Published var likes: [Song] = []
    @Published var filtered: [Song] = []
    @Published var selectedBook: Int = 0
    @Published var uiState: UiState = .idle

    init(
        prefsRepo: PrefsRepository,
        bookRepo: BookRepositoryProtocol,
        songRepo: SongRepositoryProtocol,
        subsRepo: SubscriptionRepositoryProtocol,
        reviewRepo: ReviewReqRepositoryProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.bookRepo = bookRepo
        self.songRepo = songRepo
        self.subsRepo = subsRepo
        self.reviewRepo = reviewRepo
    }
    
    func checkSubscription() {
        subsRepo.isActiveSubscriber { [weak self] isActive in
            DispatchQueue.main.async {
                self?.isActiveSubscriber = isActive
            }
        }
    }
    
    func appDidEnterBackground() {
        reviewRepo.endSession()
        showReviewPrompt = reviewRepo.shouldPromptReview()
    }
    
    func appDidBecomeActive() {
        reviewRepo.startSession()
    }
    
    func promptReview() {
        reviewRepo.promptReview(force: true)
    }
    
    func updateSlides(value: Bool) {
        prefsRepo.horizontalSlides = value
        horizontalSlides = value
    }
    
    func fetchData() {
        self.uiState = .loading("")
        Task {
            await MainActor.run {
                self.horizontalSlides = prefsRepo.horizontalSlides
                self.books = bookRepo.fetchLocalBooks()
                self.songs = songRepo.fetchLocalSongs()
                self.checkSubscription()
                self.uiState = .fetched
            }
        }
    }
    
    func filterSongs(book: Int) {
        self.uiState = .filtering

        Task {
            await MainActor.run {
                self.filtered = songs.filter { $0.book == book }
                self.likes = songs.filter { $0.liked }
                self.uiState = .filtered
            }
        }
    }
    
    func searchSongs(qry: String, byNo: Bool = false) {
        filtered = SongUtils.searchSongs(songs: songs, qry: qry, byNo: byNo)
    }
    
    func clearAllData() {
        print("Clearing data")
        self.uiState = .loading("Clearing data ...")

        Task { @MainActor in
            self.bookRepo.deleteLocalData()
            self.songRepo.deleteLocalData()
            
            prefsRepo.selectedBooks = ""
            prefsRepo.isDataSelected = false
            prefsRepo.isDataLoaded = false
            self.uiState = .loaded
        }
    }
}
