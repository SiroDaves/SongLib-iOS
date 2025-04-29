//
//  SongLibApp.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import SwiftUI

@main
struct SongLibApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
