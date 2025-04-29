//
//  HomeViewController.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadSongs()
    }
    
    private func setupUI() {
        title = "SongLib"
        view.backgroundColor = .white
        
        // Search bar setup
        searchBar.placeholder = "Search songs"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        // TableView setup
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SongCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$filteredSongs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// UITableViewDelegate & UITableViewDataSource implementation for Home
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        let song = viewModel.filteredSongs[indexPath.row]
        
        cell.textLabel?.text = song.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Here you would navigate to song detail screen
        let song = viewModel.filteredSongs[indexPath.row]
        print("Selected song: \(song.title)")
        
        // TODO: Navigate to song detail screen
    }
}

// UISearchBarDelegate implementation
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchText(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
