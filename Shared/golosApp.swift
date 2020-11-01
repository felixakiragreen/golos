//
//  golosApp.swift
//  Shared
//
//  Created by Felix Akira Green on 11/1/20.
//

import SwiftUI

@main
struct golosApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
