//
//  HomeViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation
import SwiftUI

final class MainViewModel: ObservableObject {
    private let prefsRepo: PreferencesRepository
    private let songbkRepo: SongBookRepositoryProtocol
    private let listingRepo: ListingRepositoryProtocol
    private let reviewRepo: ReviewReqRepositoryProtocol
    private let subsRepo: SubscriptionRepositoryProtocol
    
    @Published var activeSubscriber: Bool = false
    @Published var horizontalSlides: Bool = false
    @Published var showReviewPrompt: Bool = false
    
    @Published var books: [Book] = []
    @Published var songs: [Song] = []
    @Published var likes: [Song] = []
    @Published var filtered: [Song] = []
    @Published var listings: [Listing] = []
    @Published var selectedBook: Int = 0
    @Published var uiState: UiState = .idle

    init(
        prefsRepo: PreferencesRepository,
        songbkRepo: SongBookRepositoryProtocol,
        listingRepo: ListingRepositoryProtocol,
        reviewRepo: ReviewReqRepositoryProtocol,
        subsRepo: SubscriptionRepositoryProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.songbkRepo = songbkRepo
        self.listingRepo = listingRepo
        self.reviewRepo = reviewRepo
        self.subsRepo = subsRepo
    }
    
    func checkSubscription() {
        subsRepo.isActiveSubscriber { [weak self] isActive in
            DispatchQueue.main.async {
                self?.activeSubscriber = isActive
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
        uiState = .loading("")
        Task {
            await MainActor.run {
                horizontalSlides = prefsRepo.horizontalSlides
                books = songbkRepo.fetchLocalBooks()
                songs = songbkRepo.fetchLocalSongs()
                listings = listingRepo.fetchListings()
                checkSubscription()
                uiState = .fetched
            }
        }
    }
    
    func filterSongs(book: Int) {
        Task {
            await MainActor.run {
                filtered = songs.filter { $0.book == book }
                likes = songs.filter { $0.liked }
                uiState = .filtered
            }
        }
    }
    
    func searchSongs(qry: String, byNo: Bool = false) {
        filtered = SongUtils.searchSongs(songs: songs, qry: qry, byNo: byNo)
        self.uiState = .filtered
    }
    
    func addListing(title: String) {
        listingRepo.addListing(title)
        Task { @MainActor in
            listings = listingRepo.fetchListings()
            uiState = .filtered
        }
    }
    
    func likeSong(song: Song) {
        songbkRepo.likeSong(song)
        uiState = .filtered
    }
    
    func addSong(songId: Int, parentId: UUID) {
        listingRepo.addSongToListing(songId: songId, parentId: parentId)
        Task { @MainActor in
            listings = listingRepo.fetchListings()
            uiState = .filtered
        }
    }
    
    func clearAllData() {
        print("Clearing data")
        uiState = .loading("Clearing data ...")
        Task { @MainActor in
            songbkRepo.deleteLocalData()
            listingRepo.deleteListings()
            prefsRepo.resetPrefs()
            uiState = .loaded
        }
    }
}
