//
//  HomeSearch.swift
//  SongLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct HomeSearch: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchQry: String = ""
    @State private var searchByNo: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 1) {
                    SongsSearchBar(text: $searchQry, onCancel: {
                        searchQry = ""
                        viewModel.searchSongs(qry: "")
                    })
                    .onChange(of: searchQry) { newValue in
                        viewModel.searchSongs(qry: newValue, byNo: searchByNo)
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
                        
                        Button {
                            searchByNo = true
                            searchQry = ""
                            viewModel.searchSongs(qry: "", byNo: true)
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
            .navigationTitle("SongLib")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.regularMaterial, for: .navigationBar)
        }
    }
}

struct SongsSearchBar: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var onCancel: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .center) {
            if isFocused {
                Button(action: {
                    text = ""
                    isFocused = false
                    hideKeyboard()
                    onCancel?()
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.largeTitle)
                        .foregroundColor(.onPrimaryContainer)
                }
                .padding(.bottom, 5)
            }
            
            TextField("Search for songs ...", text: $text) .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 15)
                .padding(.top, 7)
                .focused($isFocused)
        }
        .padding(.horizontal)
        .animation(.easeInOut, value: isFocused)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

#Preview {
    SongsList()
}
