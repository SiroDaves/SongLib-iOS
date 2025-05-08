//
//  PresentorTabs.swift
//  SongLib
//
//  Created by Siro Daves on 07/05/2025.
//

import SwiftUI

struct PresentorTabs: View {
    let verses: [String]
    @Binding var selected: Int
    
    var body: some View {
        TabView(selection: $selected) {
            ForEach(verses.indices, id: \.self) { index in
                VerseContent(verse: verses[index])
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxHeight: .infinity)
    }
}

struct VerseContent: View {
    let verse: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(0.2),
                        radius: 8, x: 0, y: 2,
                )
            
            VStack(alignment: .leading, spacing: 15) {
                Text(verse)
                    .font(.title2)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            .padding(10)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding()
    }
}

#Preview{
    PresentorTabs(
        verses: [
            "Fear not, little flock,\nfrom the cross to the throne,\nFrom death into life\nHe went for His own;\nAll power in earth,\nall power above,\nIs given to Him\nfor the flock of His love.",
            "CHORUS\nOnly believe, only believe,\nAll things are possible,\nOnly believe, Only believe,\nonly believe,\nAll things are possible,\nonly believe.",
            "Fear not, little flock,#He goeth ahead,\nYour Shepherd selecteth\nthe path you must tread;\nThe waters of Marah\nHe’ll sweeten for thee,\nHe drank all the bitter\nin Gethsemane."
        ],
        selected: .constant(0)
    )
}
