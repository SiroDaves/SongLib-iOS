//
//  MockListingRepository.swift
//  SongLib
//
//  Created by Siro Daves on 28/08/2025.
//

import Foundation

class MockListingRepository: ListingRepositoryProtocol {
    var mockListings: [Listing] = []
    var shouldThrowError = false
    
    func fetchListings() -> [Listing] {
        return mockListings.sorted { $1.updatedAt < $0.updatedAt }
    }
    
    func addListing(_ title: String) {
        let newListing = Listing(
            id: UUID(),
            parentId: UUID(),
            songId: 0,
            title: title,
            createdAt: Date(),
            updatedAt: Date()
        )
        mockListings.append(newListing)
    }
    
    func addSongToListing(song: Song, listing: Listing) {
        let newListing = Listing(
            id: UUID(),
            parentId: listing.id,
            songId: song.songId,
            title: song.title,
            createdAt: Date(),
            updatedAt: Date()
        )
        mockListings.append(newListing)
    }
    
    func saveListing(_ listing: Listing) {
        if let index = mockListings.firstIndex(where: { $0.id == listing.id }) {
            mockListings[index] = listing
        } else {
            mockListings.append(listing)
        }
    }
    
    func updateListing(_ listing: Listing) {
        if let index = mockListings.firstIndex(where: { $0.id == listing.id }) {
            mockListings[index] = listing
        }
    }
    
    func deleteListing(withId id: UUID) {
        mockListings.removeAll { $0.id == id }
    }
    
    func deleteListings() {
        mockListings.removeAll()
    }
}
