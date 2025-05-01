//
//  BookItemView.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import SwiftUI

struct BookItemView: View {
    let book: Book
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                Text(book.subTitle)
                    .font(.subheadline)
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
        .cornerRadius(8)
        .onTapGesture {
            onTap()
        }
    }
}
