//
//  golOSApp.swift
//  Shared
//
//  Created by Felix Akira Green on 12/28/20.
//

import SwiftUI

@main
struct golOSApp: App {
	@ObservedObject private var data = TemporalData()

	var body: some Scene {
		WindowGroup {
			NavigationView {
//				ContentView()
//				TemporalEntry()
				DailyFlow(dailyAnnotations: $data.daily) {
					data.save()
				}
			}
			.onAppear {
				data.load()
			}
		}
	}
}
