//
//  SplashView.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(AppAssets.mainIcon)
                .resizable()
                .frame(width: 200, height: 200)

            Text(AppConstants.appTitle)
                .font(.system(size: 50, weight: .bold))
                .kerning(5)
                .foregroundColor(ThemeColors.primary)
                .padding(.top, 10)

            Spacer()

            Divider()
                .frame(height: 2)
                .padding(.horizontal, 50)
                .background(ThemeColors.primaryDark)

            HStack {
                Text("with ")
                    .font(.system(size: 30, weight: .bold))
                    .kerning(5)
                    .foregroundColor(ThemeColors.primary)
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(ThemeColors.primaryDark)
                Text(" from")
                    .font(.system(size: 30, weight: .bold))
                    .kerning(5)
                    .foregroundColor(ThemeColors.primary)
            }

            HStack {
                Text(AppConstants.appCredits1)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(ThemeColors.primaryDark)
                Text(" & ")
                    .font(.system(size: 20))
                    .foregroundColor(ThemeColors.primary)
                Text(AppConstants.appCredits2)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(ThemeColors.primaryDark)
            }
            .padding(.top, 10)

            Spacer().frame(height: 20)
        }
    }
}

#Preview {
    SplashView()
}
