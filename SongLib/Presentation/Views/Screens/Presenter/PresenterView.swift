//
//  PresenterView.swift
//  SongLib
//
//  Created by Siro Daves on 06/05/2025.
//

import SwiftUI
import SwiftUIPager

struct PresenterView: View {
    @StateObject private var viewModel: PresenterViewModel = {
        DiContainer.shared.resolve(PresenterViewModel.self)
    }()
    
    let song: Song
    
    @StateObject private var selectedPage = Page.first()
    @State private var showToast = false

    var body: some View {
        ZStack {
            NavigationStack {
                stateContent
            }

            if showToast {
                let toastMessage = L10n.likedSong(for: song.title, isLiked: viewModel.isLiked)

                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .task { viewModel.loadSong(song: song) }
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
            mainContent

        case .error(let msg):
            ErrorView(message: msg) {
                Task { viewModel.loadSong(song: song) }
            }

        default:
            LoadingView()
        }
    }

    private var mainContent: some View {
        PresenterContent(
            verses: viewModel.verses,
            indicators: viewModel.indicators,
            selected: selectedPage
        )
        .background(.surface)
        .navigationTitle(viewModel.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.likeSong(song: song)
                } label: {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(.primary1)
                }
            }
        }
    }
}

private struct PresenterContent: View {
    let verses: [String]
    let indicators: [String]
    @ObservedObject var selected: Page
    
    var body: some View {
        VStack(spacing: 20) {
            PresenterTabs(
                verses: verses,
                selected: selected
            )
            .frame(maxHeight: .infinity)
            
            PresenterIndicators(
                indicators: indicators,
                selected: selected
            )
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview{
    PresenterView(
        song: Song.sampleSongs[0],
    )
}
