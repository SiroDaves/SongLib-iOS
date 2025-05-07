//
//  PresentorView.swift
//  SongLib
//
//  Created by Siro Daves on 06/05/2025.
//

import SwiftUI

struct PresentorView: View {
    @StateObject private var viewModel: PresentorViewModel = {
        DiContainer.shared.resolve(PresentorViewModel.self)
    }()
    
    let song: Song
    
    @State private var selectedTabIndex = 0

    var body: some View {
        NavigationStack {
            stateContent
        }
        .task({viewModel.loadSong(song: song)})
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading(let msg):
                ProgressView()
                    .scaleEffect(5)
                    .tint(ThemeColors.primary)
            
            case .loaded:
                VStack(spacing: 0) {
                    tabContent
                    tabIndicators
                }
                .navigationTitle(viewModel.title)
                
            case .error(let msg):
                ErrorView(message: msg) {
                    Task { viewModel.loadSong(song: song) }
                }
                
            default:
                LoadingView()
        }
    }
    
    private var tabContent: some View {
        TabView(selection: $selectedTabIndex) {
            ForEach(viewModel.verses.indices, id: \.self) { index in
                VStack {
                    Spacer()
                    Text(viewModel.verses[index])
                        .font(.system(.title3))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Spacer()
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxHeight: .infinity)
    }
    
    private var tabIndicators: some View {
        HStack(spacing: 40) {
            ForEach(viewModel.verses.indices, id: \.self) { index in
                Button {
                    withAnimation {
                        selectedTabIndex = index
                    }
                } label: {
                    Text(viewModel.indicators[index])
                        .font(.title2)
                        .foregroundColor(selectedTabIndex == index ? .white : .primary)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(selectedTabIndex == index ? Color.blue : Color.clear)
                        )
                }
            }
        }
        .padding(.vertical)
        .background(.regularMaterial)
    }
    
}

#Preview{
    PresentorView(
        song: Song(
            book: 1,
            songId: 1,
            songNo: 1,
            title: "Amazing Grace",
            alias: "",
            content: "Amazing grace how sweet the sound",
            views: 1200,
            likes: 300,
            liked: true,
            created: "2024-01-01"
            ),
    )
}
