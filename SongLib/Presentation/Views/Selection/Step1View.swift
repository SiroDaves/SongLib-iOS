//
//  Step1View.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct Step1View: View {
    @StateObject private var viewModel: SelectionViewModel = {
        DiContainer.shared.resolve(SelectionViewModel.self)
    }()
    @State private var navigateToNext = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading books...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text(error)
                            .foregroundColor(.red)
                        Button("Retry") {
                            Task {
                                await viewModel.fetchBooks()
                            }
                        }
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.books.indices, id: \.self) { index in
                                let selectable = viewModel.books[index]
                                BookItemView(
                                    book: selectable.data,
                                    isSelected: selectable.isSelected
                                ) {
                                    viewModel.toggleSelection(for: selectable.data)
                                }
                            }
                        }
                        .padding()
                    }

                    Button(action: {
                        if !viewModel.selectedBooks().isEmpty {
                            navigateToNext = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Proceed")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                    }
                    .padding(.bottom)
                }

                NavigationLink(destination: Step2View(), isActive: $navigateToNext) {
                    EmptyView()
                }
            }
            .navigationTitle("Select Song Books")
            .task {
                await viewModel.fetchBooks()
            }
        }
    }
}


struct BookItemView: View {
    let book: Book
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                Text(book.subTitle)
                    .font(.subheadline)
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
        .cornerRadius(8)
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    Step1View()
}
