//
//  SettingsSections.swift
//  SongLib
//
//  Created by Siro Daves on 26/08/2025.
//

import SwiftUI

struct ThemeSectionView: View {
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

struct SlidesSectionView: View {
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

struct ProSectionView: View {
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

struct ReviewSectionView: View {
    let onReviewReq: () -> Void
    let onContactUs: () -> Void

    var body: some View {
        Section(header: Text("Feedback")) {
           Button(action: onReviewReq) {
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
            
            Button(action: onContactUs) {
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

struct ResetSectionView: View {
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
