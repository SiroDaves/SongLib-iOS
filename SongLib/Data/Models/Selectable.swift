//
//  Selectable.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

class Selectable<T>: ObservableObject {
    @Published var isSelected: Bool
    let data: T

    init(_ data: T, isSelected: Bool = false) {
        self.data = data
        self.isSelected = isSelected
    }
}
