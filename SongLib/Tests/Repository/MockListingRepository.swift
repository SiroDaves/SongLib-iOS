//
//  MockListingRepository.swift
//  SongLib
//
//  Created by Siro Daves on 28/08/2025.
//

import Foundation

class MockListingRepository: ListingRepositoryProtocol {
    func fetchChildListings(for parentId: Int) -> [Listing] {
        return mockListings
    }
    
    var mockListings: [Listing] = []
    var shouldThrowError = false
    
    func fetchListings() -> [Listing] {
        return mockListings.sorted { $1.updatedAt < $0.updatedAt }
    }
    
    func addListing(_ title: String) {
        let newListing = Listing(
            id: 1,
            parentId: 0,
            songId: 0,
            title: title,
            createdAt: Date(),
            updatedAt: Date()
        )
        mockListings.append(newListing)
    }
    
    func addSongToListing(songId: Int, parentId: Int) {
        let newListing = Listing(
            id: 1,
            parentId: parentId,
            songId: songId,
            title: "listed-song",
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
    
    func deleteListing(withId id: Int) {
        mockListings.removeAll { $0.id == id }
    }
    
    func deleteListings() {
        mockListings.removeAll()
    }
}
