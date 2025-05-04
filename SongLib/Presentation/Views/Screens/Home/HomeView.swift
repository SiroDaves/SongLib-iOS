//
//  HomeView.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = {
        DiContainer.shared.resolve(HomeViewModel.self)
    }()
    
    var body: some View {
        VStack(spacing: 0){
            Text("SongLib")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 5)
                .padding(.bottom, 5)

            Divider()
            
            switch viewModel.uiState {
                case .loading(let msg):
                    LoadingView(title: msg!)
                case .filtering:
                    ProgressView()
                        .scaleEffect(5)
                        .tint(ThemeColors.primary)
                case .filtered:
                    TabView {
                        SongsView(
                            viewModel: viewModel,
                            //onSongSelect: (Song) -> { }
                        )
                            .tabItem {
                                Label("Songs", systemImage: "magnifyingglass")
                            }
                        LikesView(viewModel: viewModel)
                            .tabItem {
                                Label("Likes", systemImage: "heart.fill")
                            }
                    }
                case .error(let msg):
                    VStack {
                        Text(msg)
                            .foregroundColor(.red)
                    }
                    .padding()
                default:
                    LoadingView()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .task {
            viewModel.fetchData()
        }
        .onChange(of: viewModel.uiState) { state in
            if case .fetched = state {
                viewModel.filterData(book: viewModel.books[0].bookId)
            }
        }
    }
}

struct LikesView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationView {
            List(viewModel.likes) { song in
                Text(song.title)
            }
            .navigationTitle("Likes")
        }
    }
}

#Preview {
    HomeView()
}
