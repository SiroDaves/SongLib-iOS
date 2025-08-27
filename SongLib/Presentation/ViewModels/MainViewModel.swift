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
    private let songbkRepo: SongBookRepositoryProtocol
    private let reviewRepo: ReviewReqRepositoryProtocol
    private let subsRepo: SubscriptionRepositoryProtocol
    
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
        songbkRepo: SongBookRepositoryProtocol,
        reviewRepo: ReviewReqRepositoryProtocol,
        subsRepo: SubscriptionRepositoryProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.songbkRepo = songbkRepo
        self.reviewRepo = reviewRepo
        self.subsRepo = subsRepo
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
                self.books = songbkRepo.fetchLocalBooks()
                self.songs = songbkRepo.fetchLocalSongs()
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
            self.songbkRepo.deleteLocalData()
            
            prefsRepo.selectedBooks = ""
            prefsRepo.isDataSelected = false
            prefsRepo.isDataLoaded = false
            self.uiState = .loaded
        }
    }
}
