//
//  HistoryRepository.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import Foundation

protocol HistoryRepositoryProtocol {
    func fetchHistories() -> [History]
    func saveHistory(_ history: History)
    func deleteHistory()
}

class HistoryRepository: HistoryRepositoryProtocol {
    private let historyData: HistoryDataManager
    
    init(historyData: HistoryDataManager) {
        self.historyData = historyData
    }
    
    func fetchHistories() -> [History] {
        let histories = historyData.fetchHistories()
        return histories.sorted { $0.createdAt < $1.createdAt }
    }
    
    func saveHistory(_ history: History) {
        historyData.saveHistory(history)
    }
    
    func deleteHistory() {
        historyData.deleteAllHistories()
    }
    
}
