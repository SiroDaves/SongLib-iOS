//
//  ContentView.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import SwiftUI

struct ContentView: View {
    private let prefsRepo: PrefsRepository
    
    @State private var goToNextScreen = false
    @State private var isDataSelected = false
    @State private var isDataLoaded = false
    
    init(prefsRepo: PrefsRepository) {
        self.prefsRepo = prefsRepo
        self.isDataSelected = prefsRepo.isDataSelected
        self.isDataLoaded = prefsRepo.isDataLoaded
    }
    
    var body: some View {
        Group {
            if goToNextScreen {
                if isDataLoaded {
                    HomeView()
                } else {
                    if isDataSelected {
                        Step1View()
                    } else {
                        Step2View()
                    }
                }
            } else {
                SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        goToNextScreen = true
                    }
                }
            }
        }
        .animation(.easeInOut, value: goToNextScreen)
    }
}
