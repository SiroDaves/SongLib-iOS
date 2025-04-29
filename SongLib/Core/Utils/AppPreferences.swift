//
//  AppPreferences.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import Foundation

class AppPreferences {
    private enum Keys {
        static let dataDownloaded = "dataDownloaded"
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var isDataDownloaded: Bool {
        get {
            return userDefaults.bool(forKey: Keys.dataDownloaded)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.dataDownloaded)
        }
    }
}
