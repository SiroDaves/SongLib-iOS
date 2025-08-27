//
//  SongViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 06/05/2025.
//

import Foundation
import SwiftUI

final class SongViewModel: ObservableObject {

    private let prefsRepo: PreferencesRepository
    private let songbkRepo: SongBookRepositoryProtocol

    @Published var uiState: UiState = .idle
    @Published var title: String = ""
    @Published var hasChorus: Bool = false
    @Published var indicators: [String] = []
    @Published var verses: [String] = []
    
    @Published var isLiked: Bool = false

    init(
        prefsRepo: PreferencesRepository,
        songbkRepo: SongBookRepositoryProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.songbkRepo = songbkRepo
    }

    func loadSong(song: Song) {
        uiState = .loading("Loading ...")
        
        indicators = []
        verses = []

        hasChorus = song.content.contains("CHORUS")
        title = SongUtils.songItemTitle(number: song.songNo, title: song.title)

        let songVerses = SongUtils.getSongVerses(songContent: song.content)
        let verseCount = songVerses.count

        if hasChorus {
            let chorus = songVerses[1].replacingOccurrences(of: "CHORUS#", with: "")

            indicators.append("1")
            indicators.append("C")
            verses.append(songVerses[0])
            verses.append(chorus)

            for i in 2..<verseCount {
                indicators.append("\(i)")
                indicators.append("C")
                verses.append(songVerses[i])
                verses.append(chorus)
            }
        } else {
            for i in 0..<verseCount {
                indicators.append("\(i + 1)")
                verses.append(songVerses[i])
            }
        }
        
        isLiked = song.liked
        uiState = .loaded
    }
    
    func likeSong(song: Song) {
        let updatedSong = Song(
            book: song.book,
            songId: song.songId,
            songNo: song.songNo,
            title: song.title,
            alias: song.alias,
            content: song.content,
            views: song.views,
            likes: song.likes,
            liked: !song.liked,
            created: song.created
        )
        
        songbkRepo.updateSong(updatedSong)
        isLiked = updatedSong.liked
        uiState = .liked
    }

}
