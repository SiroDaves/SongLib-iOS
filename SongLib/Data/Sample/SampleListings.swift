//
//  SampleListings.swift
//  SongLib
//
//  Created by Siro Daves on 28/08/2025.
//

import Foundation

extension Listing {
    static let sampleListings: [Listing] = [
        Listing(
            id: 1,
            parentId: 0,
            songId: 101,
            title: "Sunday Service",
            createdAt: Date().addingTimeInterval(-3600),
            updatedAt: Date().addingTimeInterval(-600),
            songCount: 12
        ),
        Listing(
            id: 2,
            parentId: 0,
            songId: 202,
            title: "Wedding Playlist",
            createdAt: Date().addingTimeInterval(-86400),
            updatedAt: Date().addingTimeInterval(-7200),
            songCount: 8
        )
    ]
}
