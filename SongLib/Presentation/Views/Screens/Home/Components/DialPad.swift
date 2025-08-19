//
//  DialPad.swift
//  SongLib
//
//  Created by Siro Daves on 19/08/2025.
//

import SwiftUI

struct DialPadOverlay: View {
    let onNumberClick: (String) -> Void
    let onBackspaceClick: () -> Void
    let onSearchClick: () -> Void

    var body: some View {
        VStack {
            Spacer()
            DialPad(
                onNumberClick: onNumberClick,
                onBackspaceClick: onBackspaceClick,
                onSearchClick: onSearchClick
            )
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.easeInOut, value: true)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct DialPad: View {
    let onNumberClick: (String) -> Void
    let onBackspaceClick: () -> Void
    let onSearchClick: () -> Void

    private let dialPadItems: [[Any]] = [
        ["6", "7", "8", "9"],
        ["2", "3", "4", "5"],
        ["1", "0",
         ("delete.left", { }),
         ("checkmark", { })]
    ]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<dialPadItems.count, id: \.self) { rowIndex in
                HStack(spacing: 12) {
                    ForEach(0..<dialPadItems[rowIndex].count, id: \.self) { colIndex in
                        let item = dialPadItems[rowIndex][colIndex]

                        if let label = item as? String {
                            DialButton(label: label) {
                                onNumberClick(label)
                            }
                        } else if let pair = item as? (String, () -> Void) {
                            if pair.0 == "delete.left" {
                                DialIconButton(systemName: pair.0, action: onBackspaceClick)
                            } else if pair.0 == "checkmark" {
                                DialIconButton(systemName: pair.0, action: onSearchClick)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(radius: 8)
        )
    }
}

struct DialButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.largeTitle)
                .foregroundColor(.primary1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
        .background(Circle().stroke(.primary1, lineWidth: 2))
    }
}

struct DialIconButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title)
                .foregroundColor(.primary1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
        .background(Circle().stroke(.primary1, lineWidth: 2))
    }
}

#Preview {
    DialPadOverlay(
        onNumberClick: {_ in },
        onBackspaceClick: {},
        onSearchClick: {}
    )
}
