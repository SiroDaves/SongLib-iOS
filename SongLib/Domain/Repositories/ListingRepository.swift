//
//  ListingRepository.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import Foundation

protocol ListingRepositoryProtocol {
    func fetchListings() -> [Listing]
    func saveListing(_ listing: Listing)
    func deleteListing()
}

class ListingRepository: ListingRepositoryProtocol {
    private let listingData: ListingDataManager
    
    init(listingData: ListingDataManager) {
        self.listingData = listingData
    }
    
    func fetchListings() -> [Listing] {
        let listings = listingData.fetchListings()
        return listings.sorted { $0.createdAt < $1.createdAt }
    }
    
    func saveListing(_ listing: Listing) {
        listingData.saveListing(listing)
    }
    
    func deleteListing() {
        listingData.deleteAllListings()
    }
    
}
