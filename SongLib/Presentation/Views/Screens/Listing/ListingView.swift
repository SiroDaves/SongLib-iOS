//
//  ListingView.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI

struct ListingView: View {
    @StateObject private var viewModel: SongListingViewModel = {
        DiContainer.shared.resolve(SongListingViewModel.self)
    }()
    let listing: Listing
    
    @State private var showToast = false
    @State private var toastMessage: String = ""

    var body: some View {
        ZStack {
            NavigationStack {
                stateContent
            }
            if showToast {
                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .task { viewModel.loadListing(listing: listing) }
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
                LoadingState()
                
            case .loaded:
                ListingContent(
                    viewModel: viewModel,
                    listing: listing
                )

            case .error(let msg):
                ErrorView(message: msg) { }

            default:
                LoadingView()
        }
    }
}

struct ListingContent: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: SongListingViewModel
    let listing: Listing
    
    var body: some View {
        ListedSongs(
            viewModel: viewModel,
            songs: viewModel.listedSongs
        )
        .background(.surface)
        .navigationTitle(listing.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: { Image(systemName: "chevron.backward") }
            }
        }
    }
}
