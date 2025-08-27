//
//  ListingItem.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI

struct ListingItem: View {
    let listing: Listing

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .center) {
                Text(listing.title)
                    .font(.title3)
                    .foregroundColor(.scrim)
                    .fontWeight(.bold)
                    .lineLimit(1)
            }

            Text("...")
                .lineLimit(2)
                .foregroundColor(.scrim)
                .font(.body)
                .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .contentShape(Rectangle())
    }
}
