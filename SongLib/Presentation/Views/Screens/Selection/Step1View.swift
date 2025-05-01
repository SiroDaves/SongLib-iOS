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
                    ProgressView("Fetching data ...")
                    .progressViewStyle(
                        CircularProgressViewStyle(),
                    )
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text(error).foregroundColor(.red)
                        Button("Retry") {
                            Task {
                                viewModel.fetchBooks()
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

                NavigationStack {
                    VStack {
                        NavigationLink(value: 1) {
                            Text("Proceed")
                        }
                    }
                    .navigationDestination(for: Int.self) { value in
                        if value == 1 {
                            Step2View()
                        }
                    }
                }
            }
            .navigationTitle("Select Song Books")
            .task {
                viewModel.fetchBooks()
            }
        }
    }
}

#Preview {
    Step1View()
}
