//
//  BookItemView.swift
//  SongLib
//
//  Created by Siro Daves on 02/05/2025.
//

import SwiftUI

struct BookItem: View {
    let book: Book
    let isSelected: Bool
    let onTap: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let bgColor = isSelected ? .primary1 : Color("inversePrimary")
        let txtColor = isSelected ? Color("onPrimary") : .scrim

        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(bgColor)
                .shadow(radius: 5)
            
            HStack(spacing: 15) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(txtColor)
                    .font(.system(size: 24))
                    .padding(5)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(refineTitle(txt: book.title))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(txtColor)

                    Text("\(book.songs) \(book.subTitle) songs")
                        .font(.system(size: 18))
                        .foregroundColor(txtColor)
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
    BookItem(
        book: Book.sampleBooks[0],
        isSelected: true,
        onTap: { print("Amen") }
    )
    .padding()
}

