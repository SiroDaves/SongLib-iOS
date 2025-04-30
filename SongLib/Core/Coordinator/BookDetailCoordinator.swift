//
//  BookDetailCoordinator.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI
import Swinject

final class BookDetailCoordinator: Coordinator {
    private let book: Book
    private let resolver: Resolver

    init(book: Book, resolver: Resolver) {
        self.book = book
        self.resolver = resolver
    }

    func start() -> AnyView {
        let selectionManager = resolver.resolve(SelectionService.self)!
        let analyticsService = resolver.resolve(AnalyticsServiceProtocol.self)!
        let networkService = resolver.resolve(NetworkServiceProtocol.self)!

        let viewModel = BookDetailViewModel(
            book: book,
            selectionManager: selectionManager,
            analyticsService: analyticsService,
            networkService: networkService
        )
        return AnyView(
            BookDetailView(viewModel: viewModel)
        )
    }
}
