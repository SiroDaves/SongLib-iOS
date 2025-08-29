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
    @State private var isLandscape = false
        
    var body: some View {
        GeometryReader { geo in
            let landscape = geo.size.width > geo.size.height
            
            Group {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    iPadLayout(landscape: landscape)
                } else {
                    iPhoneLayout
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.bottom)
            .task { viewModel.fetchData() }
            .onChange(of: viewModel.uiState, perform: handleStateChange)
        }
    }
    
    @ViewBuilder
    private var iPhoneLayout: some View {
        switch viewModel.uiState {
            case .loading(let msg):
                LoadingState(title: msg ?? "")
                
            case .filtering:
                ProgressView().tint(.onPrimary)
                
            case .filtered:
                HomeTabs(
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
    
    private func iPadLayout(landscape: Bool) -> some View {
//        Group {
//            if landscape {
//                NavigationSplitView {
//                } content: {
//                    iPhoneLayout
//                } detail: {
//                    Text("Detail")
//                }
//            } else {
//                iPhoneLayout
//                    .environment(\.horizontalSizeClass, .compact)
//            }
//        }
        iPhoneLayout
            .environment(\.horizontalSizeClass, .compact)
    }
    
    private func handleStateChange(_ state: UiState) {
        if case .fetched = state {
            viewModel.filterSongs(book: viewModel.books[viewModel.selectedBook].bookId)
        }
    }
}
