//
//  BookItemView.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import SwiftUI

import SwiftUI

struct BookItemView: View {
    let book: Book
    let isSelected: Bool
    let onTap: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let unselectedColor = colorScheme == .light ? Color.white : ThemeColors.primaryDark
        let backgroundColor = isSelected ? Color.accentColor : unselectedColor
        let foregroundColor = isSelected ? Color.white : ThemeColors.primary

        return ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .shadow(radius: 5)
            
            HStack(spacing: 16) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(foregroundColor)
                    .font(.system(size: 24))
                    .padding(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(refineTitle(txt: book.title))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(foregroundColor)

                    Text("\(book.songs) \(book.subTitle) songs")
                        .font(.system(size: 18))
                        .foregroundColor(foregroundColor)
                }
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            onTap()
        }
    }
}


#Preview {
    BookItemView(
        book: Book(
            bookId: 1,
            title: "Songs of Worship",
            subTitle: "worship",
            songs: 750,
            position: 1,
            bookNo: 1,
            enabled: true,
            created: "2023-07-08T16:42:09.722Z"
        ),
        isSelected: true,
        onTap: { print("Tapped book") }
    )
    .padding()
}

