//
//  PresenterIndicators.swift
//  SongLib
//
//  Created by Siro Daves on 07/05/2025.
//

import SwiftUI

struct PresenterIndicators: View {
    let indicators: [String]
    @Binding var selected: Int
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 10) {
                ForEach(indicators.indices, id: \.self) { index in
                    IndicatorButton(
                        title: indicators[index],
                        isSelected: index == selected,
                        action: { selected = index }
                    )
                }
            }
        }
        .padding(.horizontal)
    }
}

struct IndicatorButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    init(title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : ThemeColors.primary)
                .frame(width: 60, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? ThemeColors.primaryDark1 : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(ThemeColors.primary, lineWidth: isSelected ? 0 : 2)
                )
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
}

#Preview{
    PresenterIndicators(
        indicators: ["1", "C", "2" ],
        selected: .constant(0)
    )
}
