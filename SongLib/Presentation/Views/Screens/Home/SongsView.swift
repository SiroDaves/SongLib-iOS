//
//  SongsView.swift
//  SongLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct SongsView: View {
    @ObservedObject var viewModel: HomeViewModel
    var selectedSong: Song?
    //var onSongSelect: (Song) -> Void
    
    @State private var searchText: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                TextField("Search songs...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .onChange(of: searchText) { newValue in
                        viewModel.searchSongs(searchText: newValue)
                    }
                BooksListView(
                    books: viewModel.books,
                    selectedBook: viewModel.selectedBook,
                    onSelect: { index in
                        viewModel.selectedBook = viewModel.books.firstIndex(of: index) ?? 0
                        viewModel.filterSongs(book: index.bookId)
                    }
                )
                SongsListView(
                    songs: viewModel.filtered,
                    //selectedSong: selectedSong!,
                    //onTap: onSongSelect
                )
            }
            .padding()
        }
    }
}

struct BooksListView: View {
    let books: [Book]
    let selectedBook: Int
    let onSelect: (Book) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(Array(books.enumerated()), id: \.1.bookId) { index, book in
                    SearchBookItem(
                        text: book.title,
                        isSelected: index == selectedBook,
                        onPressed: {
                            //onSelect(book)
                        }
                    )
                }
            }
            .padding(5)
        }
        .frame(height: 40)
    }
}

struct SongsListView: View {
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
