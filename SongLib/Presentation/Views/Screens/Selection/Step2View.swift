//
//  HomeView.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct Step2View: View {
    @StateObject private var viewModel: SelectionViewModel = {
        DiContainer.shared.resolve(SelectionViewModel.self)
    }()
    @State private var navigateToNext = false

    var body: some View {
        NavigationView {
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
                }
                NavigationLink(destination: HomeView(), isActive: $navigateToNext) {
                    EmptyView()
                }
            }
            .task {
                 viewModel.fetchBooks()
            }
        }
    }
}

#Preview {
    Step2View()
}
