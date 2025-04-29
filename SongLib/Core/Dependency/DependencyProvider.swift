//
//  DependencyProvider.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import Swinject

class DependencyProvider {
    static let shared = DependencyProvider()
    
    private let container = Container()
    
    private init() {
        registerDependencies()
    }
    
    private func registerDependencies() {
        // Core
        container.register(AppPreferences.self) { _ in
            AppPreferences()
        }.inObjectScope(.container)
        
        // Data
        container.register(CoreDataManager.self) { _ in
            CoreDataManager.shared
        }.inObjectScope(.container)
        
        container.register(NetworkServiceProtocol.self) { _ in
            NetworkService()
        }
        
        container.register(BookRepositoryProtocol.self) { resolver in
            BookRepository(
                networkService: resolver.resolve(NetworkServiceProtocol.self)!,
                coreDataManager: resolver.resolve(CoreDataManager.self)!
            )
        }
        
        container.register(SongRepositoryProtocol.self) { resolver in
            SongRepository(
                networkService: resolver.resolve(NetworkServiceProtocol.self)!,
                coreDataManager: resolver.resolve(CoreDataManager.self)!
            )
        }
        
        // ViewModels
        container.register(SplashViewModel.self) { resolver in
            SplashViewModel(
                appPreferences: resolver.resolve(AppPreferences.self)!
            )
        }
        
        container.register(BookSelectionViewModel.self) { resolver in
            BookSelectionViewModel(
                bookRepository: resolver.resolve(BookRepositoryProtocol.self)!,
                songRepository: resolver.resolve(SongRepositoryProtocol.self)!,
                appPreferences: resolver.resolve(AppPreferences.self)!
            )
        }
        
        container.register(HomeViewModel.self) { resolver in
            HomeViewModel(
                songRepository: resolver.resolve(SongRepositoryProtocol.self)!
            )
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return container.resolve(type)
    }
}
