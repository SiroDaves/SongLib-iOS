//
//  HomeViewMock.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI
import RevenueCatUI

private struct HomeViewMock: View {
    var body: some View {
        TabView {
            HomeSearchMock()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .background(.primaryContainer)
            
            HomeLikesMock()
                .tabItem {
                    Label("Likes", systemImage: "heart.fill")
                }
                .background(.primaryContainer)
            
            HomeListingsMock()
                .tabItem {
                    Label("Listings", systemImage: "list.number")
                }
                .background(.primaryContainer)
        }
    }
}

#Preview
{
    HomeViewMock()
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            HomeViewMock()
//                .previewDevice("iPhone 16 Pro")
//                .previewDisplayName("iPhone")
//            
//            HomeViewMock()
//                .previewDevice("iPad Pro (11-inch) (4th generation)")
//                .previewInterfaceOrientation(.landscapeLeft)
//                .previewDisplayName("iPad Landscape")
//        }
//    }
//}
