//
//  AppCoordinator.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    
    init(window: UIWindow, dependencyProvider: DependencyProvider = DependencyProvider.shared) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let splashViewModel = dependencyProvider.resolve(SplashViewModel.self)!
        let splashVC = SplashViewController(viewModel: splashViewModel, appCoordinator: self)
        
        let navigationController = UINavigationController(rootViewController: splashVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showBookSelectionScreen() {
        guard let navigationController = window.rootViewController as? UINavigationController else { return }
        
        let bookSelectionViewModel = dependencyProvider.resolve(BookSelectionViewModel.self)!
        let bookSelectionVC = BookSelectionViewController(viewModel: bookSelectionViewModel, appCoordinator: self)
        
        navigationController.setViewControllers([bookSelectionVC], animated: true)
    }
    
    func showHomeScreen() {
        guard let navigationController = window.rootViewController as? UINavigationController else { return }
        
        let homeViewModel = dependencyProvider.resolve(HomeViewModel.self)!
        let homeVC = HomeViewController(viewModel: homeViewModel)
        
        navigationController.setViewControllers([homeVC], animated: true)
    }
}

// SceneDelegate.swift (partial)
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
