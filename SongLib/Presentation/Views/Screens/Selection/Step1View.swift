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
    
    @State private var path = NavigationPath()
    @State private var showNoSelectionAlert = false
    @State private var showConfirmationAlert = false

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading data ...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text(error)
                            .foregroundColor(.red)
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
                        if viewModel.selectedBooks().isEmpty {
                            showNoSelectionAlert = true
                        } else {
                            showConfirmationAlert = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Proceed")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(ThemeColors.primary)
                        .cornerRadius(10)
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("Select Songbooks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            viewModel.fetchBooks()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .alert(isPresented: $showNoSelectionAlert) {
                Alert(
                    title: Text("Oops! No selection found"),
                    message: Text("Please, just select at least 1 song book to be able to proceed to the next step."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .confirmationDialog("If you are done selecting please proceed ahead. We can always bring you back here to reselect afresh.", isPresented: $showConfirmationAlert, titleVisibility: .visible) {
                Button("Proceed") {
                    viewModel.saveBooks()
                    path = NavigationPath()
                    path.append("step2")
                }
                Button("Cancel", role: .cancel) {}
            }
            .task {
                viewModel.fetchBooks()
            }
            .navigationDestination(for: String.self) { route in
                if route == "step2" {
                    Step2View()
                }
            }
        }
    }
}

#Preview {
    Step1View()
}
