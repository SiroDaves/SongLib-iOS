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
    
    var body: some View {
        stateContent
        .edgesIgnoringSafeArea(.bottom)
        .task { viewModel.fetchData() }
        .onChange(of: viewModel.uiState, perform: handleStateChange)
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading(let msg):
                LoadingState(title: msg!)
            
            case .filtering:
                ProgressView().tint(.onPrimary)
            
            case .filtered:
                TabView {
                    if viewModel.songs.isEmpty {
                        
                    } else {
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
                    #endif
                    viewModel.promptReview()
                }
                .sheet(isPresented: $showPaywall) {
                    #if !DEBUG
                        PaywallView(displayCloseButton: true)
                    #endif
                }
               
            case .error(let msg):
                ErrorView(message: msg) {
                    Task { viewModel.fetchData() }
                }
                
            default:
                LoadingState()
        }
    }
    
    private func handleStateChange(_ state: UiState) {
        if case .fetched = state {
            viewModel.filterSongs(book: viewModel.books[viewModel.selectedBook].bookId)
        }
    }
}
