//
//  SelectionViewController.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import UIKit
import Combine

class BookSelectionViewController: UIViewController {
    private let viewModel: BookSelectionViewModel
    private var cancellables = Set<AnyCancellable>()
    private let appCoordinator: AppCoordinator
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let syncButton = UIButton(type: .system)
    
    private var selectedBooks: [Book] = []
    
    init(viewModel: BookSelectionViewModel, appCoordinator: AppCoordinator) {
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
        bindViewModel()
        viewModel.loadBooks()
    }
    
    private func setupUI() {
        title = "Select Books"
        view.backgroundColor = .white
        
        // TableView setup
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Sync Button setup
        syncButton.setTitle("Sync Selected Books", for: .normal)
        syncButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        syncButton.backgroundColor = .systemBlue
        syncButton.setTitleColor(.white, for: .normal)
        syncButton.layer.cornerRadius = 10
        syncButton.isEnabled = false
        syncButton.addTarget(self, action: #selector(syncButtonTapped), for: .touchUpInside)
        syncButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Activity Indicator setup
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        view.addSubview(tableView)
        view.addSubview(syncButton)
        view.addSubview(activityIndicator)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: syncButton.topAnchor, constant: -20),
            
            syncButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            syncButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            syncButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            syncButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$books
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.tableView.isUserInteractionEnabled = false
                    self?.syncButton.isEnabled = false
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.isUserInteractionEnabled = true
                    self?.syncButton.isEnabled = !self!.selectedBooks.isEmpty
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                let alert = UIAlertController(
                    title: "Error",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.$isSyncComplete
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.appCoordinator.showHomeScreen()
            }
            .store(in: &cancellables)
    }
    
    @objc private func syncButtonTapped() {
        viewModel.selectBooks(selectedBooks)
    }
}

// UITableViewDelegate & UITableViewDataSource implementation
extension BookSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        let book = viewModel.books[indexPath.row]
        
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = viewModel.books[indexPath.row]
        if !selectedBooks.contains(where: { $0.id == book.id }) {
            selectedBooks.append(book)
        }
        syncButton.isEnabled = !selectedBooks.isEmpty
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let book = viewModel.books[indexPath.row]
        selectedBooks.removeAll { $0.id == book.id }
        syncButton.isEnabled = !selectedBooks.isEmpty
    }
}
