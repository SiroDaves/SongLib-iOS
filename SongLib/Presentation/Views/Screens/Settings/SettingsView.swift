//
//  SettingsView.swift
//  SongLib
//
//  Created by Siro Daves on 05/08/2025.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel = {
        DiContainer.shared.resolve(SettingsViewModel.self)
    }()
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showPaywall: Bool = false
    @State private var showResetAlert: Bool = false
    @State private var restartTheApp = false
    
    var body: some View {
        Group {
            if restartTheApp {
                AnyView(SplashView())
            } else {
                AnyView(mainContent)
            }
        }
    }
    
    private var mainContent: some View {
        stateContent
        .edgesIgnoringSafeArea(.bottom)
        .task { viewModel.checkSettings() }
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading(let msg):
                LoadingState(
                    title: msg!,
                    fileName: "circle-loader",
                )
            
            case .fetched:
                
                    Form {
                        ThemeSectionView(
                            selectedTheme: $themeManager.selectedTheme
                        )

                        SlidesSectionView(
                            isOn: Binding(
                                get: { viewModel.horizontalSlides },
                                set: { viewModel.horizontalSlides = $0 }
                            )
                        )
                        
                        #if !DEBUG
                        if !viewModel.isActiveSubscriber {
                            ProSectionView { showPaywall = true }
                        }
                        #endif

                        ReviewSectionView(onReviewReq: viewModel.promptReview, onContactUs: viewModel.sendEmail)

                        ResetSectionView { showResetAlert = true }
                    }
                    .alert(L10n.resetDataAlert, isPresented: $showResetAlert) {
                        Button(L10n.cancel, role: .cancel) { }
                        Button(L10n.okay, role: .destructive) {
                            viewModel.clearAllData()
                        }
                    } message: {
                        Text(L10n.resetDataAlertDesc)
                    }
                    .sheet(isPresented: $showPaywall) {
                        PaywallView(displayCloseButton: true)
                    }
                    .navigationTitle("Settings")
                    .toolbarBackground(.regularMaterial, for: .navigationBar)
               
            case .error(let msg):
                ErrorState(message: msg) { }
                
            default:
                LoadingState()
        }
    }
    
    private func handleStateChange(_ state: UiState) {
        restartTheApp = .loaded == state
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
}
