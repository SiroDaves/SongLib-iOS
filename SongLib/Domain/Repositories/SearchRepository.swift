//
//  SearchRepository.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import Foundation

protocol SearchRepositoryProtocol {
    func fetchSearches() -> [Search]
    func saveSearch(_ search: Search)
    func deleteSearch()
}

class SearchRepository: SearchRepositoryProtocol {
    private let searchData: SearchDataManager
    
    init(searchData: SearchDataManager) {
        self.searchData = searchData
    }
    
    func fetchSearches() -> [Search] {
        let histories = searchData.fetchSearches()
        return histories.sorted { $0.createdAt < $1.createdAt }
    }
    
    func saveSearch(_ search: Search) {
        searchData.saveSearch(search)
    }
    
    func deleteSearch() {
        searchData.deleteAllSearches()
    }
    
}
