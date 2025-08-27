//
//  SongsList.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI

struct SongsList: View {
    @ObservedObject var viewModel: MainViewModel
    let songs: [Song]

    @State private var selectedSong: Song?
    @State private var showListingSheet = false
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
                NavigationLink {
                    PresenterView(song: song)
                } label: {
                    SongItem(
                        song: song,
                        height: 50,
                        isSelected: false,
                        isSearching: false
                    )
                    .contextMenu {
                        Button {
                            viewModel.likeSong(song: song)
                        } label: {
                            Label(
                                song.liked ? "Remove from Likes" : "Add to Likes",
                                systemImage:
                                    song.liked ? "heart.fill" : "heart",
                            )
                        }
                        
                        Button {
                            selectedSong = song
                            showListingSheet = true
                        } label: {
                            Label("Add to Listing", systemImage: "text.badge.plus")
                        }
                        
                        ShareLink(
                            item: SongUtils.shareText(song: song),
                        ) {
                            Label(
                                "Share this song",
                                systemImage: "square.and.arrow.up",
                            )
                        }

                    }
                }

                if index < songs.count - 1 {
                    Divider()
                }
            }
        }
        .sheet(isPresented: $showListingSheet) {
            if let song = selectedSong {
                ChooseListingSheet(
                    listings: viewModel.listings,
                    onSelect: { listing in
                        viewModel.addSong(song: song, listing: listing)
                        showListingSheet = false
                    },
                    onNewList: { title in
                        viewModel.addListing(title: title)
                        if let newListing = viewModel.listings.last {
                            viewModel.addSong(song: song, listing: newListing)
                        }
                        showListingSheet = false
                    }
                )
            }
        }
    }
}
