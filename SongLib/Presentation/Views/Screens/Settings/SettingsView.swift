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
                NavigationStack {
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

                        ReviewSectionView(
                            onReview: { viewModel.promptReview() },
                            onEmail: { viewModel.sendEmail() }
                        )

                        ResetSectionView { viewModel.promptReview() }
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
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(.regularMaterial, for: .navigationBar)
                }
               
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

private struct ThemeSectionView: View {
    @Binding var selectedTheme: AppThemeMode
    
    var body: some View {
        Section(header: Text("App Theme")) {
            Picker("Select your Theme", selection: $selectedTheme) {
                ForEach(AppThemeMode.allCases) { mode in
                    Text(mode.displayName).tag(mode)
                }
            }
            .pickerStyle(.inline)
        }
    }
}

private struct SlidesSectionView: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Section {
            HStack {
                Image(systemName: "arrow.left.and.right")
                    .frame(width: 24, height: 24)
                    .foregroundColor(.accentColor)

                VStack(alignment: .leading) {
                    Text("Song Slides")
                    Text("Swipe verses horizontally")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Toggle("", isOn: $isOn)
                    .labelsHidden()
            }
            .contentShape(Rectangle())
        }
    }
}

private struct ProSectionView: View {
    let onTap: () -> Void
    
    var body: some View {
        Section(header: Text("SongLib Pro")) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.joinPro).font(.headline)
                        Text(L10n.joinProDesc)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

private struct ReviewSectionView: View {
    let onReview: () -> Void
    let onEmail: () -> Void

    var body: some View {
        Section(header: Text("FEEDBACK")) {
            VStack(alignment: .leading, spacing: 2) {
                Button(action: onReview) {
                    HStack(spacing: 12) {
                        Image(systemName: "text.badge.star")
                        VStack(alignment: .leading, spacing: 2) {
                            Text(L10n.leaveReview)
                                .font(.headline)
                            Text(L10n.leaveReviewDesc)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                Divider()
                Button(action: onEmail) {
                    HStack(spacing: 12) {
                        Image(systemName: "envelope")
                        VStack(alignment: .leading, spacing: 2) {
                            Text(L10n.contactUs).font(.headline)
                            Text(L10n.contactUsDesc)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

private struct ResetSectionView: View {
    let onTap: () -> Void
    
    var body: some View {
        Section(header: Text("DANGER").foregroundColor(.red)) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.resetData).font(.headline).foregroundColor(.red)
                        Text(L10n.resetDataDesc)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
}
