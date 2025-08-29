//
//  MockRepository.swift
//  SongLib
//
//  Created by Siro Daves on 28/08/2025.
//

import Foundation

class MockPreferencesRepository: PreferencesRepositoryProtocol {
    var installDate: Date = Date()
    var reviewRequested: Bool = false
    var lastReviewPrompt: Date = .distantPast
    var usageTime: TimeInterval = 0
    var isDataSelected: Bool = false
    var isDataLoaded: Bool = false
    var selectedBooks: String = ""
    var horizontalSlides: Bool = false
    
    func resetPrefs() {
        selectedBooks = ""
        isDataSelected = false
        isDataLoaded = false
    }
}

class MockSubscriptionRepository: SubscriptionRepositoryProtocol {
    func isActiveSubscriber(completion: @escaping (Bool) -> Void) {
        completion(false)
    }
    
    var isActiveSubscriber: Bool = false
}

final class MockReviewReqRepository: ReviewReqRepositoryProtocol {
    private(set) var sessionStarted = false
    private(set) var sessionEnded = false
    private(set) var shouldPrompt = false
    private(set) var promptCalled = false
    private(set) var forcePromptCalled = false

    func startSession() {
        sessionStarted = true
    }

    func endSession() {
        sessionEnded = true
    }

    func shouldPromptReview() -> Bool {
        return shouldPrompt
    }

    func promptReview(force: Bool) {
        promptCalled = true
        if force { forcePromptCalled = true }
    }
}
