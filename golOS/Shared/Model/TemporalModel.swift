//
//  TemporalModel.swift
//  golOS
//
//  Created by Felix Akira Green on 2/17/21.
//

import SwiftUI

class TemporalModel: ObservableObject {
	@Environment(\.calendar) var calendar: Calendar
	// @Environment(\.physicalSpec) var location: PhysicalSpec
	// @ObservedObject var solarModel: SolarModel
	
	@Published var focalTime: Date /// this is the time that the cursor is above
	@Published var focalDate: Date /// this is the selected "day" in the day scrollview
	
	let dayRange = [
		-1, 0, 1, 2
	]
	
	init(date: Date) {
		self.focalTime = date
		self.focalDate = date
		
		updateFocal(date: date)
	}
	
	convenience init() {
		self.init(date: Date())
	}
	
	func updateFocal(date: Date) {
		if focalTime != date {
			focalTime = date
		}
		
		let startOfDay = calendar.startOfDay(for: date)
		
		if focalDate != startOfDay {
			focalDate = startOfDay
		}
	}
	
}
