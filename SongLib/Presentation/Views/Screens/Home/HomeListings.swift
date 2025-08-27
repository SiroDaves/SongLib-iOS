//
//  HomeListings.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI

struct HomeListings: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.listings.isEmpty {
                    EmptyState(
                        message: "Start adding lists of songs,\nif you don't want to see this again",
                        messageIcon: Image(systemName: "list.number")
                    )
                } else {
                    ScrollView {
                        ForEach(viewModel.listings.indices, id: \.self) { index in
                            let listing = viewModel.listings[index]

                            VStack(spacing: 0) {
                                NavigationLink {
                                    ListingView(listing: listing)
                                } label: {
                                    ListingItem(listing: listing)
                                }

                                if index < viewModel.listings.count - 1 {
                                    Divider()
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Song Listings")
            .toolbarBackground(.regularMaterial, for: .navigationBar)
        }
    }
}
