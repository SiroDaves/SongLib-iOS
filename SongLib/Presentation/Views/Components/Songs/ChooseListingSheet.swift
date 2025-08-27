//
//  ChooseListingSheet.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI

struct ChooseListingSheet: View {
    let listings: [Listing]
    let onSelect: (Listing) -> Void
    let onNewList: (String) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var newListTitle = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    Button {
                        onNewList("New List")
                    } label: {
                        Label("New list", systemImage: "plus")
                    }
                    
                    ForEach(listings) { listing in
                        Button {
                            onSelect(listing)
                        } label: {
                            HStack {
                                Image(systemName: "heart")
                                    .foregroundColor(.primary)
                                Text(listing.title)
                                Spacer()
                            }
                        }
                    }
                }
                
                Button("Done") {
                    dismiss()
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.green)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
            }
            .navigationTitle("Choose list")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
