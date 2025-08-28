//
//  HomeTabs.swift
//  SongLib
//
//  Created by Siro Daves on 29/08/2025.
//

import SwiftUI

struct HomeTabs: View {
    @ObservedObject var viewModel: MainViewModel
    @Binding var showPaywall: Bool
    
    var body: some View {
        TabView {
            if !viewModel.songs.isEmpty {
                HomeSearch(viewModel: viewModel)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .background(.primaryContainer)
                
                HomeLikes(viewModel: viewModel)
                    .tabItem {
                        Label("Likes", systemImage: "heart.fill")
                    }
                    .background(.primaryContainer)
                
                if viewModel.activeSubscriber {
                    HomeListings(viewModel: viewModel)
                        .tabItem {
                            Label("Listings", systemImage: "list.number")
                        }
                        .background(.primaryContainer)
                }
            }
            
            SettingsView(viewModel: viewModel)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .background(.primaryContainer)
        }
        .onAppear {
            #if !DEBUG
            showPaywall = !viewModel.activeSubscriber
            viewModel.promptReview()
            #endif
        }
        .sheet(isPresented: $showPaywall) {
            #if !DEBUG
            PaywallView(displayCloseButton: true)
            #endif
        }
    }
}
