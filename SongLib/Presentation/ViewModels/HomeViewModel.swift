//
//  HomeViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import Foundation
import Combine

class HomeViewModel {
    private let songRepository: SongRepositoryProtocol
    
    @Published var songs: [Song] = []
    @Published var filteredSongs: [Song] = []
    @Published var searchText: String = ""
    
    init(songRepository: SongRepositoryProtocol) {
        self.songRepository = songRepository
    }
    
    func loadSongs() {
        // Get all songs from local database
        songs = songRepository.getLocalSongs(for: nil)
        filterSongs()
    }
    
    func filterSongs() {
        if searchText.isEmpty {
            filteredSongs = songs
        } else {
            filteredSongs = songs.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.lyrics.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func updateSearchText(_ text: String) {
        searchText = text
        filterSongs()
    }
}
