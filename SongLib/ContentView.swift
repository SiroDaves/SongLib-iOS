//
//  ContentView.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var navigateToHome = false

    var body: some View {
        Group {
            if navigateToHome {
                Step1View()
            } else {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            navigateToHome = true
                        }
                    }
            }
        }
        .animation(.easeInOut, value: navigateToHome)
    }
}
