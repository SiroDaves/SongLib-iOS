//
//  PresenterTabs.swift
//  SongLib
//
//  Created by Siro Daves on 07/05/2025.
//

import SwiftUI

struct PresenterTabsV1: View {
    let verses: [String]
    @Binding var selected: Int
    private let prefs = PrefsRepository()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.onPrimary)
                .shadow(radius: 5)
            
            if prefs.horizontalSlides {
                TabView(selection: $selected) {
                    ForEach(verses.indices, id: \.self) { index in
                        VerseContentV1(verse: verses[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            } else {
                TabView(selection: $selected) {
                    ForEach(verses.indices, id: \.self) { index in
                        VerseContentV1(verse: verses[index])
                            .tag(index)
                            .rotationEffect(.degrees(-90))
                    }
                }
                .rotationEffect(.degrees(90))
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
            }
        }
        .padding()
    }
}

struct VerseContentV1: View {
    let verse: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(verse)
                .font(.largeTitle)
                .foregroundColor(.scrim)
                .multilineTextAlignment(.leading)
        }
        .padding(15)
    }
}

#Preview{
    PresenterTabsV1(
        verses: String.sampleVerses,
        selected: .constant(0)
    )
}
