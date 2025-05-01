//
//  DependencyMap.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Swinject

struct DependencyMap {
    static func registerDependencies(in container: Container) {
        container.register(CoreDataManager.self) { _ in
            CoreDataManager.shared
        }.inObjectScope(.container)
        
        container.register(ApiServiceProtocol.self) { _ in
            ApiService()
        }

        container.register(AnalyticsServiceProtocol.self) { _ in
            AnalyticsService()
        }

        container.register(LoggerProtocol.self) { _ in
            Logger()
        }
        
        container.register(BookRepositoryProtocol.self) { resolver in
            BookRepository(
                apiService: resolver.resolve(ApiServiceProtocol.self)!,
                dataManager: resolver.resolve(CoreDataManager.self)!
            )
        }
        
        container.register(SongRepositoryProtocol.self) { resolver in
            SongRepository(
                apiService: resolver.resolve(ApiServiceProtocol.self)!,
                dataManager: resolver.resolve(CoreDataManager.self)!
            )
        }
        
        container.register(BookDetailCoordinator.self) { (r, book: Book) in
            BookDetailCoordinator(
                book: book,
                resolver: r
            )
        }
        
        container.register(SelectionViewModel.self) { resolver in
            let bookRepo = resolver.resolve(BookRepositoryProtocol.self)!
            return SelectionViewModel(bookRepo: bookRepo)
        }
    }
}
