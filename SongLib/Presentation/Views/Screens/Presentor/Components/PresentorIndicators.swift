//
//  PresentorIndicators.swift
//  SongLib
//
//  Created by Siro Daves on 07/05/2025.
//

import SwiftUI

struct PresentorIndicators: View {
    let indicators: [String]
    @Binding var selected: Int
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(indicators.indices, id: \.self) { index in
                IndicatorButton(
                    title: indicators[index],
                    isSelected: index == selected,
                    action: { selected = index }
                )
            }
        }
        .padding()
    }
}

struct IndicatorButton: View {
    let title: String
    let isSelected: Bool
    let size: CGFloat
    let cornerRadius: CGFloat
    let action: () -> Void
    
    init(title: String, isSelected: Bool, size: CGFloat = 60, cornerRadius: CGFloat = 10, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.size = size
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : ThemeColors.primary)
                .frame(width: size, height: size)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(isSelected ? ThemeColors.primaryDark1 : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(ThemeColors.primary, lineWidth: isSelected ? 0 : 2)
                )
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
}

#Preview{
    PresentorIndicators(
        indicators: ["1", "C", "2" ],
        selected: .constant(0)
    )
}
