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
//            Text("SongLib")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//            Divider()
            stateContent
        }
        .edgesIgnoringSafeArea(.bottom)
        .task { viewModel.fetchData() }
        .onChange(of: viewModel.uiState, perform: handleStateChange)
    }
    
    @ViewBuilder
    private var stateContent: some View {
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
                ErrorView(message: msg) {
                    Task { viewModel.fetchData() }
                }
                
            default:
                LoadingView()
        }
    }
    
    private func handleStateChange(_ state: ViewUiState) {
        if case .fetched = state {
            viewModel.filterData(book: viewModel.books[0].bookId)
        }
    }
    
}

#Preview {
    HomeView()
}
