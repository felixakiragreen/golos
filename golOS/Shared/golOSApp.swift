//
//  golOSApp.swift
//  Shared
//
//  Created by Felix Akira Green on 2/12/21.
//

import SwiftUI

@main
struct golOSApp: App {
	// let persistenceController = PersistenceController.shared

	var body: some Scene {
		WindowGroup {
			ContentView()
			// .environment(\.managedObjectContext, persistenceController.container.viewContext)
		}
	}
}
