//
//  DependencyMap.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Swinject

struct DependencyMap {
    static func registerDependencies(in container: Container) {
        container.register(PreferencesRepository.self) { _ in
            PreferencesRepository()
        }.inObjectScope(.container)

        container.register(CoreDataManager.self) { _ in
            CoreDataManager.shared
        }.inObjectScope(.container)
        
        container.register(ApiServiceProtocol.self) { _ in
            ApiService()
        }.inObjectScope(.container)

        container.register(AnalyticsServiceProtocol.self) { _ in
            AnalyticsService()
        }.inObjectScope(.container)

        container.register(LoggerProtocol.self) { _ in
            Logger()
        }.inObjectScope(.container)
        
        container.register(BookDataManager.self) { resolver in
            BookDataManager(coreDataManager: resolver.resolve(CoreDataManager.self)!)
        }.inObjectScope(.container)
        
        container.register(SongDataManager.self) { resolver in
            SongDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
                bookDataManager: resolver.resolve(BookDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(ListingDataManager.self) { resolver in
            ListingDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SearchDataManager.self) { resolver in
            SearchDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(HistoryDataManager.self) { resolver in
            HistoryDataManager(
                coreDataManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SongBookRepositoryProtocol.self) { resolver in
            SongBookRepository(
                apiService: resolver.resolve(ApiServiceProtocol.self)!,
                bookData: resolver.resolve(BookDataManager.self)!,
                songData: resolver.resolve(SongDataManager.self)!,
                listData: resolver.resolve(ListingDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(SubscriptionRepositoryProtocol.self) { resolver in
            SubscriptionRepository()
        }.inObjectScope(.container)
        
        container.register(ReviewReqRepositoryProtocol.self) { resolver in
            ReviewReqRepository(
                prefsRepo: resolver.resolve(PreferencesRepository.self)!
            )
        }.inObjectScope(.container)
        
        container.register(SelectionViewModel.self) { resolver in
            SelectionViewModel(
                prefsRepo: resolver.resolve(PreferencesRepository.self)!,
                songbkRepo: resolver.resolve(SongBookRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(MainViewModel.self) { resolver in
            MainViewModel(
                prefsRepo: resolver.resolve(PreferencesRepository.self)!,
                songbkRepo: resolver.resolve(SongBookRepositoryProtocol.self)!,
                reviewRepo: resolver.resolve(ReviewReqRepositoryProtocol.self)!,
                subsRepo: resolver.resolve(SubscriptionRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SongViewModel.self) { resolver in
            SongViewModel(
                prefsRepo: resolver.resolve(PreferencesRepository.self)!,
                songbkRepo: resolver.resolve(SongBookRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
    }
}
