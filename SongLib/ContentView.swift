//
//  ContentView.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var books: [Book] = []

    var body: some View {
        NavigationView {
            List(books, id: \.id) { book in
                if let coordinator = DiContainer.shared.container.resolve(
                    BookDetailCoordinator.self,
                    argument: book
                ) {
                    NavigationLink(
                        destination: coordinator.start()
                    ) {
                        Text(book.title)
                    }
                } else {
                    Text("Unable to load book details")
                }
            }
            .navigationTitle("Select Song Books")
        }
        .task {
            let networkService = DiContainer.shared.container.resolve(NetworkServiceProtocol.self)
            books = await networkService?.fetchBooks() ?? []
        }
    }
}
