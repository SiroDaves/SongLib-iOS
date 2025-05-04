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
                    .scaleEffect(5)
                    .tint(ThemeColors.primary)
                Text(title)
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    LoadingView()
}
