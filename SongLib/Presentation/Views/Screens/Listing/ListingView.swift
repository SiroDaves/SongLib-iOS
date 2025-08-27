//
//  ListingView.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI
import SwiftUIPager

struct ListingView: View {
    @StateObject private var viewModel: SongViewModel = {
        DiContainer.shared.resolve(SongViewModel.self)
    }()
    let listing: Listing
    
    @State private var showToast = false

    var body: some View {
        ZStack {
            NavigationStack {
                stateContent
            }

//            if showToast {
//                let toastMessage = L10n.likedSong(for: song.title, isLiked: viewModel.isLiked)
//
//                ToastView(message: toastMessage)
//                    .transition(.move(edge: .bottom).combined(with: .opacity))
//                    .zIndex(1)
//            }
        }
        .toolbar(.hidden, for: .tabBar)
        .task {  }
        .onChange(of: viewModel.uiState) { newState in
            if case .liked = newState {
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showToast = false
                }
            }
        }
    }

    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
        case .loading:
            ProgressView()
                .scaleEffect(5)
                .tint(.onPrimary)
            
        case .loaded, .liked:
            LoadingView()

        case .error(let msg):
            ErrorView(message: msg) { }

        default:
            LoadingView()
        }
    }
}
