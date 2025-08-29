//
//  ListingRepository.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import Foundation

protocol ListingRepositoryProtocol {
    func fetchListings() -> [Listing]
    func fetchChildListings(for parentId: Int) -> [Listing]
    func saveListing(title: String, parentId: Int, songId: Int)
    func addSongToListing(songId: Int, parentId: Int)
    func updateListing(_ listing: Listing)
    func deleteListing(withId id: Int)
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
    
    func fetchChildListings(for parentId: Int) -> [Listing] {
        let listings = listData.fetchListings()
        return listings.sorted { $1.updatedAt < $0.updatedAt }
    }
    
    func saveListing(title: String, parentId: Int, songId: Int) {
        listData.saveListing(
            title: title,
            parentId: parentId,
            songId: songId
        )
    }
    
    func addSongToListing(songId: Int, parentId: Int) {
        listData.saveListing(
            title: "",
            parentId: parentId,
            songId: songId
        )
    }
    
    func updateListing(_ listing: Listing) {
        listData.updateListing(listing)
    }
    
    func deleteListing(withId id: Int) {
        listData.deleteListing(withId: id)
    }
    
    func deleteListings() {
        listData.deleteAllListings()
    }
    
}
