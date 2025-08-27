//
//  HomeListings.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI

struct HomeListings: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var showingNewListingAlert = false
    @State private var newListingTitle = ""

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
                        .background(.surface)
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Song Listings")
            .toolbarBackground(.regularMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingNewListingAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("New Listing", isPresented: $showingNewListingAlert) {
                TextField("Listing title", text: $newListingTitle)
                
                Button("Add", action: {
                    guard !newListingTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    viewModel.addListing(title: newListingTitle)
                    newListingTitle = ""
                })
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Enter a title for your new song listing")
            }
        }
    }
}
