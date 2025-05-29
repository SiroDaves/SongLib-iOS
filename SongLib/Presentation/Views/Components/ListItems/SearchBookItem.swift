//
//  SearchBookItem.swift
//  SongLib
//
//  Created by Siro Daves on 04/05/2025.
//

import SwiftUI

struct SearchBookItem: View {
    let text: String
    let isSelected: Bool
    let onPressed: (() -> Void)?

    var body: some View {
        Button(action: {
            onPressed?()
        }) {
            Text(text)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .white : .black)
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .background(isSelected ? ThemeColors.primary2 : ThemeColors.accent)
                .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

#Preview{
    SearchBookItem(
        text: "Songs of Worship",
        isSelected: true,
        onPressed: { }
    )
}
