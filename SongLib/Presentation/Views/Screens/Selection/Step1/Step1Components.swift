//
//  Step1Components.swift
//  SongLib
//
//  Created by Siro Daves on 15/08/2025.
//

import SwiftUI

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
                HStack(spacing: 5) {
                    Image(systemName: "checkmark")
                    Text("Proceed")
                }
                .frame(width: 150)
                .foregroundColor(.onPrimaryContainer)
                .padding()
                .background(.primaryContainer)
                .cornerRadius(10)
            }
            .padding(.bottom)
            .background(Color.clear)
        }
    }
}

struct ConfirmationUIModifier: ViewModifier {
    let message: String
    @Binding var isPresented: Bool
    let onProceed: () -> Void
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            content.popover(isPresented: $isPresented) {
                VStack(spacing: 20) {
                    Text(message)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Proceed") {
                        isPresented = false
                        onProceed()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    
                    Button("Cancel") {
                        isPresented = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .frame(width: 320, height: 200)
                .padding()
            }
        } else {
            content.confirmationDialog(
                message,
                isPresented: $isPresented,
                titleVisibility: .visible
            ) {
                Button("Proceed") { onProceed() }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}
