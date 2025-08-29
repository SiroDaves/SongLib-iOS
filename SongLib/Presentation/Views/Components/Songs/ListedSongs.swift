//
//  ListedSongs.swift
//  SongLib
//
//  Created by Siro Daves on 29/08/2025.
//

import SwiftUI
import SwiftUIModal

struct ListedSongs: View {
    @ObservedObject var viewModel: SongListingViewModel
    let songs: [Song]

    @State private var selectedSong: Song?
    @State private var showToast = false
    @State private var toastMessage: String = ""
    
    var body: some View {
        ZStack {
            stateContent

            if showToast {
                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
//        .sheet(item: $selectedSong) { song in
//            ChooseListingSheet(
//                listings: viewModel.listings,
//                onSelect: { listing in
//                    addSongToListing(song: song, listing: listing)
//                },
//                onNewList: { title in
//                    viewModel.addListing(title: title)
//                    if let newListing = viewModel.listings.last {
//                        addSongToListing(song: song, listing: newListing)
//                    }
//                }
//            )
//        }
    }
    
    func addSongToListing(song: Song, listing: Listing){
        selectedSong = nil
        viewModel.addSong(song: song, listing: listing)
        toastMessage = "\(song.title) added to \(listing.title) listing"
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showToast = false
        }
    }
    
    @ViewBuilder
    private var stateContent: some View {
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
//                    .contextMenu {
//                        Button {
//                            viewModel.likeSong(song: song)
//                            toastMessage = L10n.likedSong(for: song.title, isLiked: !song.liked)
//                            showToast = true
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                showToast = false
//                            }
//                        } label: {
//                            Label(
//                                song.liked ? "Remove from Likes" : "Add to Likes",
//                                systemImage: song.liked ? "heart.fill" : "heart"
//                            )
//                        }
//                        
//                        Button {
//                            selectedSong = song
//                        } label: {
//                            Label("Add to Listing", systemImage: "text.badge.plus")
//                        }
//                        
//                        ShareLink(
//                            item: SongUtils.shareText(song: song)
//                        ) {
//                            Label(
//                                "Share this song",
//                                systemImage: "square.and.arrow.up"
//                            )
//                        }
//                    }
                }

                if index < songs.count - 1 {
                    Divider()
                }
            }
        }
    }
}
