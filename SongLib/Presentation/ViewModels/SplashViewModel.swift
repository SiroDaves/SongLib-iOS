//
//  SplashViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import Foundation
import Combine

class SplashViewModel {
    private let appPreferences: AppPreferences
    @Published var isDataDownloaded: Bool
    
    init(appPreferences: AppPreferences) {
        self.appPreferences = appPreferences
        self.isDataDownloaded = appPreferences.isDataDownloaded
    }
    
    func checkIfDataIsDownloaded() -> Bool {
        return appPreferences.isDataDownloaded
    }
}
