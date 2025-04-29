//
//  SplashViewController.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import UIKit
import Combine

class SplashViewController: UIViewController {
    private let viewModel: SplashViewModel
    private var cancellables = Set<AnyCancellable>()
    private let appCoordinator: AppCoordinator
    
    init(viewModel: SplashViewModel, appCoordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.appCoordinator = appCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Show splash for a short time then navigate
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.navigateToNextScreen()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "SongLib"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func navigateToNextScreen() {
        if viewModel.checkIfDataIsDownloaded() {
            appCoordinator.showHomeScreen()
        } else {
            appCoordinator.showBookSelectionScreen()
        }
    }
}
