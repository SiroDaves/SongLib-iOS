//
//  TrackingRepository.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import Foundation

protocol TrackingRepositoryProtocol {
    func fetchHistories() -> [History]
    func fetchSearches() -> [Search]
    func saveHistory(_ history: History)
    func saveSearch(_ search: Search)
    func deleteHistory()
    func deleteSearch()
}

class TrackingRepository: TrackingRepositoryProtocol {
    private let historyData: HistoryDataManager
    private let searchData: SearchDataManager
    
    init(historyData: HistoryDataManager, searchData: SearchDataManager) {
        self.historyData = historyData
        self.searchData = searchData
    }
    
    func fetchHistories() -> [History] {
        let histories = historyData.fetchHistories()
        return histories.sorted { $0.createdAt < $1.createdAt }
    }
    
    func fetchSearches() -> [Search] {
        let histories = searchData.fetchSearches()
        return histories.sorted { $0.createdAt < $1.createdAt }
    }
    
    func saveHistory(_ history: History) {
        historyData.saveHistory(history)
    }
    
    func saveSearch(_ search: Search) {
        searchData.saveSearch(search)
    }
    
    func deleteHistory() {
        historyData.deleteAllHistories()
    }
    
    func deleteSearch() {
        searchData.deleteAllSearches()
    }
    
}
