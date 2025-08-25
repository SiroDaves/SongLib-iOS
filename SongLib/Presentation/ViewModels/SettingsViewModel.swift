//
//  SettingsViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 25/08/2025.
//

import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    private let prefsRepo: PrefsRepository
    private let bookRepo: BookRepositoryProtocol
    private let songRepo: SongRepositoryProtocol
    private let subsRepo: SubscriptionRepositoryProtocol
    private let reviewRepo: ReviewReqRepositoryProtocol

    @Published var isActiveSubscriber: Bool = false
    @Published var horizontalSlides: Bool = false
    
    @Published var uiState: UiState = .idle
    
    init(
        prefsRepo: PrefsRepository,
        bookRepo: BookRepositoryProtocol,
        songRepo: SongRepositoryProtocol,
        subsRepo: SubscriptionRepositoryProtocol,
        reviewRepo: ReviewReqRepositoryProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.bookRepo = bookRepo
        self.songRepo = songRepo
        self.subsRepo = subsRepo
        self.reviewRepo = reviewRepo
    }
    
    func checkSubscription() {
        self.horizontalSlides = prefsRepo.horizontalSlides
        subsRepo.isActiveSubscriber { [weak self] isActive in
            DispatchQueue.main.async {
                self?.isActiveSubscriber = isActive
            }
        }
    }
    
    func promptReview() {
        reviewRepo.requestReview()
    }
    
    func checkSettings() {
        Task { @MainActor in
            self.checkSubscription()
            self.uiState = .fetched
        }
    }
    
    func clearAllData() {
        print("Clearing data")
        self.uiState = .loading("Loading data ...")

        Task { @MainActor in
            self.bookRepo.deleteLocalData()
            self.songRepo.deleteLocalData()
            
            prefsRepo.selectedBooks = ""
            prefsRepo.isDataSelected = false
            prefsRepo.isDataLoaded = false
            self.uiState = .loaded
        }
    }
    
    func sendEmail() {
        let subject = "SongLib Feedback"
        let body = "Hi, \n\nI would like share some things about the app..."
        let email = "futuristicken@gmail.com"
        
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let url = URL(string: "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}
