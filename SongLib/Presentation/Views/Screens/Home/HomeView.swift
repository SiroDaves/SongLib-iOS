//
//  HomeView.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI
import RevenueCatUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = {
        DiContainer.shared.resolve(HomeViewModel.self)
    }()
    
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
                LoadingState()
            
            case .filtered:
                TabView {
                    HomeSearch(viewModel: viewModel)
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                    .background(.primaryContainer)
                    if viewModel.isActiveSubscriber {
                        HomeLikes(viewModel: viewModel)
                            .tabItem {
                                Label("Likes", systemImage: "heart.fill")
                            }
                    }
                    SettingsView(
                        isActiveSubscriber: viewModel.isActiveSubscriber
                    )
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                    .background(.primaryContainer)
                }
                .onAppear {
                    #if !DEBUG
                        showPaywall = !viewModel.isActiveSubscriber
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
