//
//  SettingsView.swift
//  SongLib
//
//  Created by Siro Daves on 05/08/2025.
//

import SwiftUI

enum AppThemeMode: String, CaseIterable, Identifiable {
    case light, dark, system
    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .light: return "Light Theme"
        case .dark: return "Dark Theme"
        case .system: return "System Default"
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    private let prefs = PrefsRepository()
    
    var body: some View {
        Form {
            Section(header: Text("App Theme")) {
                Picker("Select your Theme", selection: Binding(
                    get: { themeManager.selectedTheme },
                    set: { themeManager.selectedTheme = $0 }
                )) {
                    ForEach(AppThemeMode.allCases) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
                .pickerStyle(.inline)
            }

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
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
        .environmentObject(ThemeManager())
}
