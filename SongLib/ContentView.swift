//
//  ContentView.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import SwiftUI

struct ContentView: View {
    private let prefsRepo: PreferencesRepository
    
    @State private var navigateToNextScreen = false
    
    init(prefsRepo: PreferencesRepository) {
        self.prefsRepo = prefsRepo
    }
    
    var body: some View {
        Group {
            if navigateToNextScreen {
                if prefsRepo.isDataLoaded {
                    HomeView()
                } else {
                    if prefsRepo.isDataSelected {
                        Step2View()
                    } else {
                        Step1View()
                    }
                }
            } else {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            navigateToNextScreen = true
                        }
                    }
            }
        }
        .animation(.easeInOut, value: navigateToNextScreen)
    }
}
