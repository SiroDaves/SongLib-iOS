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
            ScrollView {
                ForEach(Array(viewModel.listings.enumerated()), id: \.element.id) { index, listing in
                    NavigationLink {
                        ListingView(listing: listing)
                    } label: {
                        ListingItem(
                            listing: listing
                        )
                    }

                    if index < listing.count - 1 {
                        Divider()
                    }
                }
                .background(.surface)
                .padding(.vertical)
            }
            .navigationTitle("Song Listings")
            .toolbarBackground(.regularMaterial, for: .navigationBar)
        }
    }
}
