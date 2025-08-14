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
                .foregroundColor(.onPrimary)
                .padding(.top, 10)

            Spacer()

            Divider()
                .frame(height: 1)
                .padding(.horizontal, 50)
                .background(.secondaryContainer)

            HStack {
                Text("with ")
                    .font(.system(size: 30, weight: .bold))
                    .kerning(5)
                    .foregroundColor(.onPrimary)
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.secondaryContainer)
                Text(" from")
                    .font(.system(size: 30, weight: .bold))
                    .kerning(5)
                    .foregroundColor(.onPrimary)
            }

            HStack {
                Text(AppConstants.appCredits1)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.secondaryContainer)
                Text(" & ")
                    .font(.system(size: 20))
                    .foregroundColor(.onPrimary)
                Text(AppConstants.appCredits2)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.secondaryContainer)
            }
            .padding(.top, 10)

            Spacer().frame(height: 20)
        }.padding()
    }
}

#Preview {
    SplashView()
}
