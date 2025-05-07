//
//  PresentorViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 06/05/2025.
//


import Foundation
import SwiftUI

final class PresentorViewModel: ObservableObject {

    private let prefsRepo: PrefsRepository
    private let songRepo: SongRepositoryProtocol

    @Published var uiState: ViewUiState = .idle
    @Published var title: String = ""
    @Published var hasChorus: Bool = false
    @Published var indicators: [String] = []
    @Published var verses: [String] = []

    init(
        prefsRepo: PrefsRepository,
        songRepo: SongRepositoryProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.songRepo = songRepo
    }

    func loadSong(song: Song) {
        uiState = .loading("Loading ...")

        hasChorus = song.content.contains("CHORUS")
        title = songItemTitle(number: song.songNo, title: song.title)

        let songVerses = song.content.components(separatedBy: "##")
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
        
        uiState = .loaded
    }
}
