//
//  LoadingView.swift
//  SongLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct LoadingView: View {
    var title: String = "Loading data ..."
    var backgroundColor: Color = Color(.systemBackground).opacity(0.9)

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 100) {
                ProgressView()
                    .scaleEffect(3)
                    .tint(.onPrimary)
                Text(title)
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(.red)
                .padding()
            
            Button("Retry", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct EmptyState: View {
    
    var body: some View {
        VStack(spacing: 20) {
            Image(AppAssets.emptyIcon)
                .resizable()
                .frame(width: 200, height: 200)

            Text("Nothing here at the moment")
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(.onPrimary)
                .padding(.horizontal)

        }
        .padding()
    }
}

#Preview {
    LoadingView()
}
