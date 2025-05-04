//
//  LoadingView.swift
//  SongLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct LoadingView: View {
    var title: String = "Loading data ..."

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
                .opacity(0.9)

            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(2.5)
                Text(title)
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
    }
}


#Preview {
    LoadingView()
}
