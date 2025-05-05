//
//  LikesView.swift
//  SongLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct LikesView: View {
    @ObservedObject var viewModel: HomeViewModel
    var selectedSong: Song?
    //var onSongSelect: (Song) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                LikesListView(
                    songs: viewModel.likes,
                    //selectedSong: selectedSong!,
                    //onTap: onSongSelect
                )
            }
            .padding()
        }
    }
}

struct LikesListView: View {
    let songs: [Song]
    //let selectedSong: Song
    //let onTap: (Song, Bool) -> Void

    var body: some View {
        VStack(spacing: 8) {
            ForEach(songs) { song in
                SearchSongItem(
                    song: song,
                    height: 50,
                    isSelected: false,
                    //isSelected: isBigScreen ? song.id == selectedSong.id : false,
                    isSearching: false,
                    onTap: {
                        //onTap(song, !isBigScreen)
                    },
                )
            }
        }
        .padding(.horizontal)
    }
}
