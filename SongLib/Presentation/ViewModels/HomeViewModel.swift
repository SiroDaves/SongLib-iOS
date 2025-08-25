//
//  HomeViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    private let prefsRepo: PrefsRepository
    private let bookRepo: BookRepositoryProtocol
    private let songRepo: SongRepositoryProtocol
    private let subsRepo: SubscriptionRepositoryProtocol
    private let reviewRepo: ReviewReqRepositoryProtocol
    
    @Published var isActiveSubscriber: Bool = false
    @Published var showReviewPrompt: Bool = false
    
    @Published var books: [Book] = []
    @Published var songs: [Song] = []
    @Published var likes: [Song] = []
    @Published var filtered: [Song] = []
    @Published var uiState: UiState = .idle
    @Published var selectedBook: Int = 0

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
        subsRepo.isActiveSubscriber { [weak self] isActive in
            DispatchQueue.main.async {
                self?.isActiveSubscriber = isActive
            }
        }
    }
    
    func appDidEnterBackground() {
        reviewRepo.endSession()
        showReviewPrompt = reviewRepo.shouldPromptReview()
    }
    
    func appDidBecomeActive() {
        reviewRepo.startSession()
    }
    
    func requestReview() {
        reviewRepo.requestReview()
    }
    
    func fetchData() {
        self.uiState = .loading("")

        Task {
            await MainActor.run {
                self.books = bookRepo.fetchLocalBooks()
                self.songs = songRepo.fetchLocalSongs()
                self.checkSubscription()
                self.uiState = .fetched
            }
        }
    }
    
    func filterSongs(book: Int) {
        self.uiState = .filtering

        Task {
            await MainActor.run {
                self.filtered = songs.filter { $0.book == book }
                self.likes = songs.filter { $0.liked }
                self.uiState = .filtered
            }
        }
    }
    
    func searchSongs(qry: String, byNo: Bool = false) {
        let query = qry.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else {
            filtered = songs
            return
        }
        
        if byNo {
            if let number = Int(query) {
                filtered = songs.filter { $0.songNo == number }
            } else {
                filtered = []
            }
            return
        }
        
        let charsPattern = try! NSRegularExpression(pattern: "[!,]", options: [])
        
        let words: [String]
        if query.contains(",") {
            words = query.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces).lowercased() }
        } else {
            words = [query.lowercased()]
        }
        
        let escapedWords = words.map { NSRegularExpression.escapedPattern(for: $0) }
        let pattern = escapedWords.joined(separator: ".*")
        let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        
        filtered = songs.filter { song in
            let title = charsPattern.stringByReplacingMatches(in: song.title, range: NSRange(song.title.startIndex..., in: song.title), withTemplate: "").lowercased()
            let alias = charsPattern.stringByReplacingMatches(in: song.alias, range: NSRange(song.alias.startIndex..., in: song.alias), withTemplate: "").lowercased()
            let content = charsPattern.stringByReplacingMatches(in: song.content, range: NSRange(song.content.startIndex..., in: song.content), withTemplate: "").lowercased()
            
            let fields = [title, alias, content]
            return fields.contains { field in
                regex.firstMatch(in: field, range: NSRange(field.startIndex..., in: field)) != nil
            }
        }
    }

}
