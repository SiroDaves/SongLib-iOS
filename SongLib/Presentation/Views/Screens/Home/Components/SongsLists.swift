//
//  SongsLists.swift
//  SongLib
//
//  Created by Siro Daves on 19/08/2025.
//

import SwiftUI

struct BooksListView: View {
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

struct SongsListView: View {
    let songs: [Song]

    var body: some View {
        ScrollView {
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
}

struct SongsList: View {
    @State private var searchQry: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 1) {
                SongsSearchBar(text: $searchQry, onCancel: {
                    searchQry = ""
                })
                .onChange(of: searchQry) { newValue in
                }

                BooksListView(
                    books: Book.sampleBooks,
                    selectedBook: 0,
                    onSelect: { book in
                    }
                )
                
                Spacer()
                ZStack(alignment: .bottomTrailing) {
                    SongsListView(songs: Song.sampleSongs)
                    
                    Button {
                          
                    } label: {
                        Image(systemName: "circle.grid.3x3.fill")
                            .font(.title.weight(.semibold))
                            .padding()
                            .foregroundColor(.onPrimaryContainer)
                            .background(.primaryContainer)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)

                    }
                    .padding()
                    
                    DialPadOverlay(
                        onNumberClick: {_ in },
                        onBackspaceClick: {},
                        onSearchClick: {}
                    )
                    
                }
            }
            .background(.surface)
            .padding(.vertical)
        }
    }
}

#Preview {
    SongsList()
}
