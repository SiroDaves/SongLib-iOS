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
    @ObservedObject var viewModel: MainViewModel
    
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
        NavigationStack {
            Form {
                ThemeSectionView(
                    selectedTheme: $themeManager.selectedTheme
                )

                SlidesSectionView(
                    isOn: Binding(
                        get: { viewModel.horizontalSlides },
                        set: { viewModel.updateSlides(value: $0) }
                    )
                )
                
                #if !DEBUG
                if !isActiveSubscriber {
                    ProSectionView { showPaywall = true }
                }
                #endif

                ReviewSectionView(
                    onReviewReq: viewModel.promptReview,
                    onContactUs: AppUtils.sendEmail,
                )

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
        }
    }
    
}
