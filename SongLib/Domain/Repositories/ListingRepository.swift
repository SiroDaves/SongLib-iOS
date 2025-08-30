//
//  ListingRepository.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import Foundation

protocol ListingRepositoryProtocol {
    func fetchListings(for parent: Int) -> [SongListing]
    func fetchListItems(for parent: Int) -> [SongListItem]
    func saveListing(_ parent: Int, title: String)
    func saveListItem(_ parent: Int, song: Int)
    func updateListing(_ listing: SongListing)
    func updateListItem(_ listItem: SongListItem)
    func deleteListing(with id: Int)
    func deleteListings(with id: Int)
    func deleteListItem(with id: Int)
    func deleteListItems(with id: Int)
    func deleteListings()
    func deleteListItems()
}

class ListingRepository: ListingRepositoryProtocol {
    private let listData: SongListingDataManager
    private let itemData: SongListItemDataManager
    
    init(
        listData: SongListingDataManager,
         itemData: SongListItemDataManager
    ) {
        self.listData = listData
        self.itemData = itemData
    }
    
    func fetchListings(for parent: Int) -> [SongListing] {
        let listings = listData.fetchListings(with: parent)
        return listings.sorted { $1.modified < $0.modified }
    }
    
    func fetchListItems(for parent: Int) -> [SongListItem] {
        let listItems = itemData.fetchListItems(with: parent)
        return listItems.sorted { $1.modified < $0.modified }
    }
    
    func saveListing(_ parent: Int, title: String) {
        listData.saveListing(parent, title: title)
    }
    
    func saveListItem(_ parent: Int, song: Int) {
        itemData.saveListItem(parent, song: song)
    }
    
    func updateListing(_ listing: SongListing) {
        listData.updateListing(listing)
    }
    
    func updateListItem(_ listItem: SongListItem) {
        itemData.updateListItem(listItem)
    }
    
    func deleteListing(with id: Int) {
        listData.deleteListing(with: id)
    }
    
    func deleteListings(with id: Int) {
        listData.deleteListings(with: id)
    }
    
    func deleteListItem(with id: Int) {
        itemData.deleteListItem(with: id)
    }
    
    func deleteListItems(with id: Int) {
        itemData.deleteListItems(with: id)
    }
    
    func deleteListings() {
        listData.deleteAllListings()
    }
    
    func deleteListItems() {
        itemData.deleteAllListItems()
    }
    
}
