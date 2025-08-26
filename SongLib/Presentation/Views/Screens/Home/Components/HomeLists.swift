//
//  HomeLists.swift
//  SongLib
//
//  Created by Siro Daves on 19/08/2025.
//

import SwiftUI

struct BooksList: View {
    let books: [Book]
    let selectedBook: Int
    let onSelect: (Book) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack() {
                ForEach(Array(books.enumerated()), id: \.1.bookId) { index, book in
                    SearchBookItem(
                        text: book.title,
                        isSelected: index == selectedBook,
                        onPressed: { onSelect(book) }
                    )
                }
            }
        }
        .padding(.leading, 5)
        .frame(height: 35)
    }
}

struct SongsList: View {
    let songs: [Song]

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
                NavigationLink {
                    PresenterView(song: song)
                } label: {
                    SearchSongItem(
                        song: song,
                        height: 50,
                        isSelected: false,
                        isSearching: false
                    )
                }

                if index < songs.count - 1 {
                    Divider()
                }
            }
        }
    }
}
