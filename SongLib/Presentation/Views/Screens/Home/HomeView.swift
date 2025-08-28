//
//  HomeView.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI
import RevenueCatUI

struct HomeView: View {
    @StateObject private var viewModel: MainViewModel = {
        DiContainer.shared.resolve(MainViewModel.self)
    }()
    
    @State private var showSettings: Bool = false
    @State private var showPaywall: Bool = false
    @State private var selectedSong: Song? = nil
    
    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                iPadLayout
            } else {
                iPhoneLayout
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .task { viewModel.fetchData() }
        .onChange(of: viewModel.uiState, perform: handleStateChange)
    }
    
    @ViewBuilder
    private var iPhoneLayout: some View {
        switch viewModel.uiState {
        case .loading(let msg):
            LoadingState(title: msg ?? "")
            
        case .filtering:
            ProgressView().tint(.onPrimary)
            
        case .filtered:
            HomeTabView(
                viewModel: viewModel,
                showPaywall: $showPaywall
            )
            
        case .error(let msg):
            ErrorView(message: msg) {
                Task { viewModel.fetchData() }
            }
            
        default:
            LoadingState()
        }
    }
    
    private var iPadLayout: some View {
        NavigationSplitView {
            SongSidebar(
                songs: viewModel.songs,
                onSelect: { selectedSong = $0 }
            )
        } detail: {
            if let song = selectedSong {
                PresenterView(song: song)
            } else {
                Text("Select a song")
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func handleStateChange(_ state: UiState) {
        if case .fetched = state {
            viewModel.filterSongs(book: viewModel.books[viewModel.selectedBook].bookId)
        }
    }
}

private struct HomeTabView: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var showPaywall: Bool
    
    var body: some View {
        TabView {
            if !viewModel.songs.isEmpty {
                HomeSearch(viewModel: viewModel)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .background(.primaryContainer)
                
                HomeLikes(viewModel: viewModel)
                    .tabItem {
                        Label("Likes", systemImage: "heart.fill")
                    }
                    .background(.primaryContainer)
                
                if viewModel.activeSubscriber {
                    HomeListings(viewModel: viewModel)
                        .tabItem {
                            Label("Listings", systemImage: "list.number")
                        }
                        .background(.primaryContainer)
                }
            }
            
            SettingsView(viewModel: viewModel)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .background(.primaryContainer)
        }
        .onAppear {
            #if !DEBUG
            showPaywall = !viewModel.activeSubscriber
            viewModel.promptReview()
            #endif
        }
        .sheet(isPresented: $showPaywall) {
            #if !DEBUG
            PaywallView(displayCloseButton: true)
            #endif
        }
    }
}

private struct SongSidebar: View {
    let songs: [Song]
    let onSelect: (Song) -> Void
    
    var body: some View {
        List(songs) { song in
            Button {
                onSelect(song)
            } label: {
                Text(song.title)
            }
        }
        .navigationTitle("Songs")
    }
}

#Preview {
    HomeView()
        .environmentObject(MockMainViewModel.make())
}
