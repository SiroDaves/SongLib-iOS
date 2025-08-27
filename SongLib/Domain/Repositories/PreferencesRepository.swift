//
//  PreferencesRepository.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

class PreferencesRepository {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var installDate: Date {
        get { userDefaults.object(forKey: PrefConstants.installDate) as? Date ?? Date() }
        set { userDefaults.set(newValue, forKey: PrefConstants.installDate) }
    }
    
    var reviewRequested: Bool {
        get { userDefaults.bool(forKey: PrefConstants.reviewRequested) }
        set { userDefaults.set(newValue, forKey: PrefConstants.reviewRequested) }
    }
    
    var lastReviewPrompt: Date {
        get { userDefaults.object(forKey: PrefConstants.lastReviewPrompt) as? Date ?? .distantPast }
        set { userDefaults.set(newValue, forKey: PrefConstants.lastReviewPrompt) }
    }
    
    var usageTime: TimeInterval {
        get { userDefaults.double(forKey: PrefConstants.usageTime) }
        set { userDefaults.set(newValue, forKey: PrefConstants.usageTime) }
    }
    
    var isDataSelected: Bool {
        get { userDefaults.bool(forKey: PrefConstants.isSelected) }
        set { userDefaults.set(newValue, forKey: PrefConstants.isSelected) }
    }
    
    var isDataLoaded: Bool {
        get { userDefaults.bool(forKey: PrefConstants.isLoaded) }
        set { userDefaults.set(newValue, forKey: PrefConstants.isLoaded) }
    }
    
    var selectedBooks: String {
        get { userDefaults.string(forKey: PrefConstants.selectedBooks) ?? "" }
        set { userDefaults.set(newValue, forKey: PrefConstants.selectedBooks) }
    }
    
    var horizontalSlides: Bool {
        get { userDefaults.bool(forKey: PrefConstants.horizontalSlides) }
        set { userDefaults.set(newValue, forKey: PrefConstants.horizontalSlides) }
    }
}
