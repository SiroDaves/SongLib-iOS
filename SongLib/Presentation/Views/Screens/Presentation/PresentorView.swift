//
//  PresentorView.swift
//  SongLib
//
//  Created by Siro Daves on 06/05/2025.
//

import SwiftUI

struct PresentorView: View {
    let song: Song

    var body: some View {
        VStack {
            Text("Song Details")
            Text(song.title)
            // add more song details here
        }
    }
}
