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
                switch viewModel.uiState {
                    case .loading(let msg):
                        LoadingView(title: msg!)
                    case .saving(let msg):
                        LoadingView(title: msg!)
                    case .saved:
                        LoadingView()
                    case .error(let msg):
                        VStack {
                            Text(msg)
                                .foregroundColor(.red)
                            Button("Retry") {
                                Task {
                                    viewModel.fetchBooks()
                                }
                            }
                        }
                        .padding()
                    default:
                        BookSelectionView(
                            viewModel: viewModel,
                            showNoSelectionAlert: $showNoSelectionAlert,
                            showConfirmationAlert: $showConfirmationAlert
                        )
                }
            }
            .navigationTitle("Select Songbooks")
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
                }
                Button("Cancel", role: .cancel) {}
            }
            .task {
                viewModel.fetchBooks()
            }
            .onChange(of: viewModel.uiState) { state in
                if case .saved = state {
                    path = NavigationPath()
                    path.append("step2")
                }
            }
            .navigationDestination(for: String.self) { route in
                if route == "step2" {
                    Step2View()
                }
            }
        }
    }
}

struct BookSelectionView: View {
    @ObservedObject var viewModel: SelectionViewModel
    @Binding var showNoSelectionAlert: Bool
    @Binding var showConfirmationAlert: Bool

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.books.indices, id: \.self) { index in
                        let selectable = viewModel.books[index]
                        BookItem(
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
}

#Preview {
    Step1View()
}
