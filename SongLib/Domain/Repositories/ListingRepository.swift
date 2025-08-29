//
//  ListingRepository.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import Foundation

protocol ListingRepositoryProtocol {
    func fetchListings() -> [SongListing]
    func fetchChildListings(for parent: Int) -> [SongListing]
    func saveListing(_ parent: Int, song: Int, title: String)
    func addSongToListing(_ parent: Int, song: Int)
    func updateListing(_ listing: SongListing)
    func deleteListing(with id: Int)
    func deleteListings()
}

class ListingRepository: ListingRepositoryProtocol {
    private let listData: SongListingDataManager
    
    init(listData: SongListingDataManager) {
        self.listData = listData
    }
    
    func fetchListings() -> [SongListing] {
        let listings = listData.fetchListings()
        return listings.sorted { $1.modified < $0.modified }
    }
    
    func fetchChildListings(for parent: Int) -> [SongListing] {
        let listings = listData.fetchListings()
        return listings.sorted { $1.modified < $0.modified }
    }
    
    func saveListing(_ parent: Int, song: Int, title: String) {
        listData.saveListing(parent, song: song, title: title)
    }
    
    func addSongToListing(_ parent: Int, song: Int) {
        listData.saveListing(parent, song: song, title: "")
    }
    
    func updateListing(_ listing: SongListing) {
        listData.updateListing(listing)
    }
    
    func deleteListing(with id: Int) {
        listData.deleteListing(with: id)
    }
    
    func deleteListings() {
        listData.deleteAllListings()
    }
    
}
