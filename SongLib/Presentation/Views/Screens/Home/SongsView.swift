//
//  SongsView.swift
//  SongLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct SongsView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                TextField("Search songs ...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .onChange(of: searchText) { newValue in
                        viewModel.searchSongs(searchText: newValue)
                    }

                BooksListView(
                    books: viewModel.books,
                    selectedBook: viewModel.selectedBook,
                    onSelect: { book in
                        viewModel.selectedBook = viewModel.books.firstIndex(of: book) ?? 0
                        viewModel.filterSongs(book: book.bookId)
                    }
                )

                SongsListView(songs: viewModel.filtered)
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
                        onPressed: { onSelect(book) }
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

    var body: some View {
        List(songs) { song in
            NavigationLink {
                PresentorView(
                    song: song,
                )
            } label: {
                SearchSongItem(
                    song: song,
                    height: 50,
                    isSelected: false,
                    isSearching: false
                )
            }
        }
        .listStyle(.plain)
    }
}
