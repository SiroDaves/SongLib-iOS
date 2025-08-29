//
//  ListingRepository.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import Foundation

protocol ListingRepositoryProtocol {
    func fetchListings() -> [Listing]
    func fetchChildListings(for parentId: UUID) -> [Listing]
    func addListing(_ listing: String)
    func saveListing(_ listing: Listing)
    func addSongToListing(songId: Int, parentId: UUID)
    func updateListing(_ listing: Listing)
    func deleteListing(withId id: UUID)
    func deleteListings()
}

class ListingRepository: ListingRepositoryProtocol {
    private let listData: ListingDataManager
    
    init(listData: ListingDataManager) {
        self.listData = listData
    }
    
    func fetchListings() -> [Listing] {
        let listings = listData.fetchListings()
        return listings.sorted { $1.updatedAt < $0.updatedAt }
    }
    
    func fetchChildListings(for parentId: UUID) -> [Listing] {
        let listings = listData.fetchListings()
        return listings.sorted { $1.updatedAt < $0.updatedAt }
    }
    
    func addListing(_ title: String) {
        let newListing = Listing(
            id: UUID(),
            parentId: UUID(),
            songId: 0,
            title: title,
            createdAt: Date(),
            updatedAt: Date(),
        )
        listData.saveListing(newListing)
    }
    
    func addSongToListing(songId: Int, parentId: UUID) {
        let newListing = Listing(
            id: UUID(),
            parentId: parentId,
            songId: songId,
            title: "child-listing",
            createdAt: Date(),
            updatedAt: Date(),
        )
        listData.saveListing(newListing)
    }
    
    func updateListing(_ listing: Listing) {
        listData.updateListing(listing)
    }
    
    func deleteListing(withId id: UUID) {
        listData.deleteListing(withId: id)
    }
    
    func saveListing(_ listing: Listing) {
        listData.saveListing(listing)
    }
    
    func deleteListings() {
        listData.deleteAllListings()
    }
    
}
