//
//  TrackingRepository.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import Foundation

protocol TrackingRepositoryProtocol {
    func fetchViews() -> [SongView]
    func fetchQueries() -> [Query]
    func saveView(_ songId: Int)
    func saveQuery(_ title: String)
    func deleteView()
    func deleteQuery()
}

class TrackingRepository: TrackingRepositoryProtocol {
    private let viewData: SongViewDataManager
    private let queryData: QueryDataManager
    
    init(viewData: SongViewDataManager, queryData: QueryDataManager) {
        self.viewData = viewData
        self.queryData = queryData
    }
    
    func fetchViews() -> [SongView] {
        let views = viewData.fetchViews()
        return views.sorted { $0.created < $1.created }
    }
    
    func fetchQueries() -> [Query] {
        let queries = queryData.fetchQueries()
        return queries.sorted { $0.created < $1.created }
    }
    
    func saveView(_ songId: Int) {
        viewData.saveView(songId)
    }
    
    func saveQuery(_ title: String) {
        queryData.saveQuery(title)
    }
    
    func deleteView() {
        viewData.deleteAllViews()
    }
    
    func deleteQuery() {
        queryData.deleteAllQueries()
    }
    
}
