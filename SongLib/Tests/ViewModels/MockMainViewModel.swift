//
//  MockMainViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 28/08/2025.
//

import SwiftUI

final class MockMainViewModel {
    static func make() -> MainViewModel {
        let vm = MainViewModel(
            prefsRepo: PreferencesRepository(),
            songbkRepo: MockSongBookRepository(),
            listingRepo: MockListingRepository(),
            reviewRepo: MockReviewReqRepository(),
            subsRepo: MockSubscriptionRepository()
        )

        vm.books = Book.sampleBooks
        vm.songs = Song.sampleSongs
        vm.listings = Listing.sampleListings
        vm.filtered = vm.songs
        vm.activeSubscriber = true
        vm.horizontalSlides = true
        vm.showReviewPrompt = false
        vm.uiState = .filtered

        return vm
    }
}
