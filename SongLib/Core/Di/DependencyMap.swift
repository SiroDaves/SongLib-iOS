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
            BookDataManager(cdManager: resolver.resolve(CoreDataManager.self)!)
        }.inObjectScope(.container)
        
        container.register(SongDataManager.self) { resolver in
            SongDataManager(
                cdManager: resolver.resolve(CoreDataManager.self)!,
                bdManager: resolver.resolve(BookDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(SongListingDataManager.self) { resolver in
            SongListingDataManager(
                cdManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SongListItemDataManager.self) { resolver in
            SongListItemDataManager(
                cdManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(QueryDataManager.self) { resolver in
            QueryDataManager(
                cdManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SongViewDataManager.self) { resolver in
            SongViewDataManager(
                cdManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SongBookRepositoryProtocol.self) { resolver in
            SongBookRepository(
                apiService: resolver.resolve(ApiServiceProtocol.self)!,
                bookData: resolver.resolve(BookDataManager.self)!,
                songData: resolver.resolve(SongDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(ListingRepositoryProtocol.self) { resolver in
            ListingRepository(
                listData: resolver.resolve(SongListingDataManager.self)!,
                itemData: resolver.resolve(SongListItemDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(SubscriptionRepositoryProtocol.self) { resolver in
            SubscriptionRepository()
        }.inObjectScope(.container)
        
        container.register(TrackingRepositoryProtocol.self) { resolver in
            TrackingRepository(
                viewData: resolver.resolve(SongViewDataManager.self)!,
                queryData: resolver.resolve(QueryDataManager.self)!
            )
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
                listingRepo: resolver.resolve(ListingRepositoryProtocol.self)!,
                reviewRepo: resolver.resolve(ReviewReqRepositoryProtocol.self)!,
                subsRepo: resolver.resolve(SubscriptionRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SongListingViewModel.self) { resolver in
            SongListingViewModel(
                prefsRepo: resolver.resolve(PreferencesRepository.self)!,
                songbkRepo: resolver.resolve(SongBookRepositoryProtocol.self)!,
                listingRepo: resolver.resolve(ListingRepositoryProtocol.self)!,
                subsRepo: resolver.resolve(SubscriptionRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
    }
}
