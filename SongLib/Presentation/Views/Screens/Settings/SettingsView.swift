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
    
    var body: some View {
        Form {
            ThemeSectionView(
                selectedTheme: $themeManager.selectedTheme
            )

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

                    Toggle("", isOn: Binding(
                        get: { prefs.horizontalSlides },
                        set: { prefs.horizontalSlides = $0 }
                    ))
                    .labelsHidden()
                }
                .contentShape(Rectangle())
            }
            
            #if !DEBUG
            if !viewModel.isActiveSubscriber {
                ProSectionView { showPaywall = true }
            }
            #endif

            ReviewSectionView(
                onReview: viewModel.requestReview,
                onEmail: viewModel.sendEmail
            )

            ResetSectionView { showResetAlert = true }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(displayCloseButton: true)
        }
        .navigationTitle("Settings")
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

private struct ProSectionView: View {
    let onTap: () -> Void
    
    var body: some View {
        Section(header: Text("SongLib Pro")) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Join SongLib Pro")
                            .font(.headline)
                        Text("Join SongLib Pro, Exprience advanced search, lots of exclusive features as a way to support the developer of SongLib")
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
        Section(header: Text("MAONI")) {
            VStack(alignment: .leading, spacing: 2) {
                Button(action: onReview) {
                    HStack(spacing: 12) {
                        Image(systemName: "text.badge.star")
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Tupe review")
                                .font(.headline)
                            Text("Unaweza kutupa review ili kitumizi hizi kionekane kwa wengine")
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
                            Text("Wasiliana nasi")
                                .font(.headline)
                            Text("Iwapo una malalamishi/maoni, tutumie barua pepe. Usikose kuweka picha za skrini (screenshot) nyingi uwezavyo.")
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
        Section(header: Text("HATARI").foregroundColor(.red)) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Weka upya data")
                            .font(.headline).foregroundColor(.red)
                        Text("Unaweza kufuta data yote iliyoko na uanze kudondoa upya")
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
