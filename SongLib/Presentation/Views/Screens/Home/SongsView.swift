//
//  SongsView.swift
//  SongLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct SongsView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchQry: String = ""
    @State private var searchByNo: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 1) {
                TextField("Search for songs ...", text: $searchQry)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                    .onChange(of: searchQry) { newValue in
                        viewModel.searchSongs(qry: newValue)
                    }

                BooksListView(
                    books: viewModel.books,
                    selectedBook: viewModel.selectedBook,
                    onSelect: { book in
                        viewModel.selectedBook = viewModel.books.firstIndex(of: book) ?? 0
                        viewModel.filterSongs(book: book.bookId)
                    }
                )
                
                Spacer()
                ZStack(alignment: .bottomTrailing) {
                    SongsListView(songs: viewModel.filtered)
                    
                    DialPadOverlay(
                        visible: true,
                        onNumberClick: {_ in },
                        onBackspaceClick: {},
                        onSearchClick: {}
                    )
                    
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
                    
                    if searchByNo {
                        DialPadOverlay(
                            visible: true,
                            onNumberClick: { num in
                                searchQry += num
                                viewModel.searchSongs(qry: searchQry, byNo: true)
                            },
                            onBackspaceClick: {
                                if !searchQry.isEmpty {
                                    searchQry.removeLast()
                                    viewModel.searchSongs(qry: searchQry, byNo: true)
                                }
                            },
                            onSearchClick: {
                                viewModel.searchSongs(qry: searchQry, byNo: true)
                                searchByNo = false
                            }
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: searchByNo)
                    }
                }
            }
            .background(.surface)
            .padding(.vertical)
        }
    }
}

struct SongsList: View {
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 1) {
                TextField("Search songs ...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                    .onChange(of: searchText) { newValue in
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
                        visible: true,
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
