//
//  DependencyMap.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Swinject

struct DependencyMap {
    static func registerDependencies(in container: Container) {
        container.register(ApiServiceProtocol.self) { _ in
            ApiService()
        }

        container.register(AnalyticsServiceProtocol.self) { _ in
            AnalyticsService()
        }

        container.register(LoggerProtocol.self) { _ in
            Logger()
        }

        container.register(SelectionService.self) { _ in
            SelectionManager()
        }
        
        container.register(BookDetailCoordinator.self) { (r, book: Book) in
            BookDetailCoordinator(
                book: book,
                resolver: r
            )
        }
    }
}
