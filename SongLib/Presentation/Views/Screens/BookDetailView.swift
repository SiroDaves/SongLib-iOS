//
//  BookDetailView.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//


import SwiftUI

struct BookDetailView: View {
    @ObservedObject var viewModel: BookDetailViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.book.title)
                .font(.title)
            Button("Add to Cart") {
                viewModel.addToCart()
            }
        }
        .padding()
    }
}
