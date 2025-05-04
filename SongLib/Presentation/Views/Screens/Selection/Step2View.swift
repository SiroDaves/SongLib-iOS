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
    
    @State private var path = NavigationPath()

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
                        LoadingView()
                }
            }
            .task {
                viewModel.fetchSongs()
            }
            .onChange(of: viewModel.uiState) { state in
                if case .saved = state {
                    path = NavigationPath()
                    path.append("home")
                } else if case .fetched = state {
                    viewModel.saveSongs()
                }
            }
            .navigationDestination(for: String.self) { route in
                if route == "home" {
                    HomeView()
                }
            }
        }
    }
}

#Preview {
    Step2View()
}
