//
//  PresenterView.swift
//  SongLib
//
//  Created by Siro Daves on 06/05/2025.
//

import SwiftUI

struct PresenterView: View {
    @StateObject private var viewModel: PresenterViewModel = {
        DiContainer.shared.resolve(PresenterViewModel.self)
    }()
    
    let song: Song
    
    @State private var selectedTabIndex = 0
    @State private var isLiked = false

    var body: some View {
        NavigationStack {
            stateContent
        }
        .task({viewModel.loadSong(song: song)})
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading:
                ProgressView()
                    .scaleEffect(5)
                    .tint(.primary1)
            
            case .loaded:
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
        VStack(spacing: 20) {
            PresenterTabs(
                verses: viewModel.verses,
                selected: $selectedTabIndex
            )
            .frame(maxHeight: .infinity)
            PresenterIndicators(
                indicators: viewModel.indicators,
                selected: $selectedTabIndex
            )
            .fixedSize(horizontal: false, vertical: true)
        }
        .background(.accent2)
        .navigationTitle(viewModel.title)
        //.toolbarBackground(.primary1, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("Song liked")
                } label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(.primaryDark2)
                }
            }
        }
    }
}

#Preview{
    PresenterView(
        song: Song(
            book: 1,
            songId: 1,
            songNo: 1,
            title: "Only Believe",
            alias: "",
            content: "Fear not, little flock,#from the cross to the throne,#From death into life#He went for His own;#All power in earth,#all power above,#Is given to Him#for the flock of His love.##CHORUS#Only believe, only believe,#All things are possible,#Only believe, Only believe,#only believe,#All things are possible,#only believe.##(Lord, I believe...#(Lord, I receive. .#(Jesus Is here...##Fear not, little flock,#He goeth ahead,#Your Shepherd selecteth#the path you must tread;#The waters of Marah#He’ll sweeten for thee,#He drank all the bitter#in Gethsemane.##Fear not, little flock,#whatever your lot,#He enters all rooms,#'the doors being shut;'#He never forsakes,#He never is gone,#So count on His presence#in darkness and dawn.",
            views: 1200,
            likes: 300,
            liked: true,
            created: "2024-01-01"
            ),
    )
}
