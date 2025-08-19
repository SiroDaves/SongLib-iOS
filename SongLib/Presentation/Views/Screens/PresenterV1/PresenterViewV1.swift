//
//  PresenterView.swift
//  SongLib
//
//  Created by Siro Daves on 06/05/2025.
//

import SwiftUI

struct PresenterViewV1: View {
    @StateObject private var viewModel: PresenterViewModel = {
        DiContainer.shared.resolve(PresenterViewModel.self)
    }()
    
    let song: Song
    
    @State private var selectedTabIndex = 0
    @State private var showToast = false

    var body: some View {
        ZStack {
           NavigationStack {
               stateContent
           }
           
            if showToast {
                let toastMessage = viewModel.isLiked
                    ? "\(song.title) added to your likes"
                    : "\(song.title) removed from your likes"
                
                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }

       }
        .task({viewModel.loadSong(song: song)})
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
            
            case .loaded:
                mainContent
            
            case .liked:
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
        PresenterContentV1(
            verses: viewModel.verses,
            indicators: viewModel.indicators,
            selectedTabIndex: $selectedTabIndex
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

private struct PresenterContentV1: View {
    let verses: [String]
    let indicators: [String]
    @Binding var selectedTabIndex: Int
    
    var body: some View {
        VStack(spacing: 20) {
            PresenterTabsV1(
                verses: verses,
                selected: $selectedTabIndex
            )
            .frame(maxHeight: .infinity)
            
            PresenterIndicatorsV1(
                indicators: indicators,
                selected: $selectedTabIndex
            )
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview{
    PresenterViewV1(
        song: Song.sampleSongs[0],
    )
}
