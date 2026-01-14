//
//  shareApp.swift
//  share
//
//  Created by Jean-Philippe Deis Nuel on 14/01/2026.
//

import SwiftUI
import SwiftData

@main
struct shareApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SavedLink.self,
        ])
        // IMPORTANT: You must enable "App Groups" in Xcode for both targets and add "group.s1933.share"
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            groupContainer: .identifier("group.s1933.share.data")
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // Fallback for when App Groups are not yet enabled/configured in Xcode
            print("Could not create ModelContainer with App Group: \(error). Falling back to standard.")
            let fallbackConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            return try! ModelContainer(for: schema, configurations: [fallbackConfig])
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
