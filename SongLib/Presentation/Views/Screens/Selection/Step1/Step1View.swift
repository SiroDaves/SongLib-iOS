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
    
    @State private var showNoSelectionAlert = false
    @State private var showConfirmationAlert = false
    @State private var navigateToNextScreen = false

    var body: some View {
        Group {
            if navigateToNextScreen {
                Step2View()
            } else {
                mainContent
            }
        }
    }
    
    private var mainContent: some View {
        VStack {
            Text("Select Songbooks")
                .font(.title2)
                .foregroundColor(.onPrimaryContainer)
            stateContent.background(.surface)
        }
        .background(.primaryContainer)
        .alert(isPresented: $showNoSelectionAlert) {
            noSelectionAlert
        }
        .applyConfirmationUI(
            message: "If you are done selecting please proceed ahead. We can always bring you back here to reselect afresh.",
            isPresented: $showConfirmationAlert,
            onProceed: { viewModel.saveBooks() }
        )
        .task { viewModel.fetchBooks() }
        .onChange(of: viewModel.uiState, perform: handleStateChange)
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
        case .loading(let msg):
            LoadingState(
                title: msg ?? "Loading books ...",
                fileName: "loading-hand"
            )
            
        case .saving(let msg):
            LoadingState(
                title: msg ?? "Saving selection ...",
                fileName: "cloud-download"
            )
            
        case .saved:
            LoadingView()
            
        case .error(let msg):
            ErrorView(message: msg) {
                Task { viewModel.fetchBooks() }
            }
            
        default:
            BookSelectionView(
                viewModel: viewModel,
                showNoSelectionAlert: $showNoSelectionAlert,
                showConfirmationAlert: $showConfirmationAlert
            )
        }
    }
    
    private var noSelectionAlert: Alert {
        Alert(
            title: Text("Oops! No selection found"),
            message: Text("Please select at least 1 song book to proceed to the next step."),
            dismissButton: .default(Text("OK"))
        )
    }
    
    private func handleStateChange(_ state: UiState) {
        navigateToNextScreen = (.saved == state)
    }
}

extension View {
    func applyConfirmationUI(
        message: String,
        isPresented: Binding<Bool>,
        onProceed: @escaping () -> Void
    ) -> some View {
        self.modifier(ConfirmationUIModifier(
            message: message,
            isPresented: isPresented,
            onProceed: onProceed
        ))
    }
}

#Preview {
    Step1View()
}
