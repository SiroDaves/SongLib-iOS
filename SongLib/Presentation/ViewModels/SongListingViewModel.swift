//
//  SongViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 06/05/2025.
//

import Foundation
import SwiftUI

final class SongListingViewModel: ObservableObject {
    private let prefsRepo: PreferencesRepository
    private let songbkRepo: SongBookRepositoryProtocol
    private let listingRepo: ListingRepositoryProtocol
    private let subsRepo: SubscriptionRepositoryProtocol

    @Published var uiState: UiState = .idle
    @Published var title: String = ""
    @Published var hasChorus: Bool = false
    @Published var indicators: [String] = []
    @Published var verses: [String] = []
    
    @Published var songs: [Song] = []
    @Published var listedSongs: [Song] = []
    @Published var listings: [SongListing] = []
    
    @Published var isLiked: Bool = false
    @Published var activeSubscriber: Bool = false

    init(
        prefsRepo: PreferencesRepository,
        songbkRepo: SongBookRepositoryProtocol,
        listingRepo: ListingRepositoryProtocol,
        subsRepo: SubscriptionRepositoryProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.songbkRepo = songbkRepo
        self.listingRepo = listingRepo
        self.subsRepo = subsRepo
    }
    
    func checkSubscription() {
        subsRepo.isActiveSubscriber { [weak self] isActive in
            DispatchQueue.main.async {
                self?.activeSubscriber = isActive
            }
        }
    }
    func loadListing(listing: SongListing) {
        uiState = .loading("")
        
        Task {
            await MainActor.run {
                checkSubscription()
                listings = listingRepo.fetchListings(for: listing.parent)
                
                listedSongs.removeAll()
                for listing in listings {
//                    print("Listing \(listing.id)")
//                    if let song = songbkRepo.fetchSong(withId: listing.songId) {
//                        listedSongs.append(song)
//                    } else {
//                        print("⚠️ Missing song \(listing.songId)")
//                    }
                }
                
                uiState = .loaded
            }
        }
    }

    func loadSong(song: Song) {
        uiState = .loading("Loading ...")
        
        indicators = []
        verses = []

        hasChorus = song.content.contains("CHORUS")
        title = SongUtils.songItemTitle(number: song.songNo, title: song.title)

        let songVerses = SongUtils.getSongVerses(songContent: song.content)
        let verseCount = songVerses.count

        if hasChorus {
            let chorus = songVerses[1].replacingOccurrences(of: "CHORUS#", with: "")

            indicators.append("1")
            indicators.append("C")
            verses.append(songVerses[0])
            verses.append(chorus)

            for i in 2..<verseCount {
                indicators.append("\(i)")
                indicators.append("C")
                verses.append(songVerses[i])
                verses.append(chorus)
            }
        } else {
            for i in 0..<verseCount {
                indicators.append("\(i + 1)")
                verses.append(songVerses[i])
            }
        }
        
        isLiked = song.liked
        uiState = .loaded
    }
    
    func likeSong(song: Song) {
        songbkRepo.likeSong(song)
        isLiked = !song.liked
        uiState = .liked
    }
    
    func saveListing(_ parent: Int, song: Int, title: String) {
        listingRepo.saveListing(parent, title: title)
        Task { @MainActor in
            listings = listingRepo.fetchListings(for: 0)
            uiState = .filtered
        }
    }
    
    func saveListItem(_ parent: Int, song: Int) {
        listingRepo.saveListItem(parent, song: song)
        Task { @MainActor in
            listings = listingRepo.fetchListings(for: 0)
            uiState = .filtered
        }
    }
    
}
