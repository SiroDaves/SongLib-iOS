//
//  HomeView.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("SongLib")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 16)
                .padding(.bottom, 8)

            Divider()

            TabView {
                SongsView()
                    .tabItem {
                        Label("Songs", systemImage: "magnifyingglass")
                    }

                LikesView()
                    .tabItem {
                        Label("Likes", systemImage: "heart.fill")
                    }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SongsView: View {
    var body: some View {
        NavigationView {
            Text("Songs List")
        }
    }
}

struct LikesView: View {
    var body: some View {
        NavigationView {
            Text("Liked Songs")
        }
    }
}


#Preview {
    HomeView()
}
