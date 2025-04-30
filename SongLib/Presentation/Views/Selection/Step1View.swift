//
//  Step1View.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct Step1View: View {
    @StateObject private var viewModel = Step1ViewModel()
    @State private var showConfirmAlert = false
    @State private var showEmptyAlert = false
    @Environment(\.horizontalSizeClass) var hSizeClass

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Books...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text("Error: \(error)")
                        Button("Retry") {
                            viewModel.fetchBooks()
                        }
                    }
                } else {
                    let layout = hSizeClass == .regular
                        ? AnyLayout(GridLayout())
                        : AnyLayout(ListLayout())

                    layout {
                        ForEach(viewModel.books) { book in
                            BookRow(book: book) {
                                viewModel.toggleSelection(for: book)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Books")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.fetchBooks) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        if viewModel.selectedBooks().isEmpty {
                            showEmptyAlert = true
                        } else {
                            showConfirmAlert = true
                        }
                    } label: {
                        Label("Proceed", systemImage: "checkmark")
                            .font(.headline)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .onAppear {
                viewModel.fetchBooks()
            }
            .alert("No Books Selected", isPresented: $showEmptyAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please select at least one book before proceeding.")
            }
            .alert("Done Selecting?", isPresented: $showConfirmAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Proceed") {
                    viewModel.saveBooks()
                    // Navigate to next screen here
                }
            } message: {
                Text("You've selected \(viewModel.selectedBooks().count) book(s). Proceed?")
            }
        }
    }
}

struct BookRow: View {
    let book: Book
    let onTap: () -> Void

    var body: some View {
        HStack {
            Text(book.title)
            Spacer()
            if book.isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(book.isSelected ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(8)
        .onTapGesture { onTap() }
    }
}

struct GridLayout: Layout {
    func callAsFunction(@ViewBuilder content: () -> some View) -> some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: content)
    }
}

struct ListLayout: Layout {
    func callAsFunction(@ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10, content: content)
    }
}
