//
//  Selectable.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Foundation

struct Selectable<T>: Identifiable {
    let id = UUID()
    var data: T
    var isSelected: Bool
}

enum ViewUiState: Equatable {
    case idle
    case loading(String? = nil)
    case saving(String? = nil)
    case fetched
    case saved
    case error(String)
}
