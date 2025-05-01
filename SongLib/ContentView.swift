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
    
    init(prefsRepo: PrefsRepository) {
        self.prefsRepo = prefsRepo
    }
    
    var body: some View {
        Group {
            if goToNextScreen {
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
                            goToNextScreen = true
                        }
                    }
            }
        }
        .animation(.easeInOut, value: goToNextScreen)
    }
}
