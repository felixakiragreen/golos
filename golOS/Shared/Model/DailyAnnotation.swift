//
//  DailyAnnotation.swift
//  golOS
//
//  Created by Felix Akira Green on 1/3/21.
//

import SwiftUI

protocol Annotatable {
	var data: [Datum] { get set }
}

protocol Daily {
	var start: Date? { get set }
	var stop: Date? { get set }
}

/**

 Then I can add protocols for circadian, XP, whatever

 */

/*
 TODO: FIGURE OUT HOW THE PURE TEXT INTERFACE WORKS

 perhaps it could be use as an embelishment, like a semi-opaque monospace font in a background... in the meanwhile

if I log ~sleep.whatever in the future... it will be .planned
	Ex: wind_down.planned, then wind_down.actual (if actual doesn't exist, assume it's planned)
	
.planned
.actual

Logging in past, normal

You can 

 */

struct DailyAnnotation: Identifiable, Codable, Annotatable {
	let id: UUID
	var data: [Datum]

	init(data: [Datum]) {
		self.id = UUID()
		self.data = data
	}
}

extension DailyAnnotation: Daily {
	init() {
		self.id = UUID()
		self.data = []
		
		// theoretically this should create a new start
		self.start = nil
	}
	
	init(start: Date) {
		self.id = UUID()
		self.data = []
		
		// theoretically this should create a new start
		self.start = start
	}
	
	
	// TODO: document the purpose of each thing
	var start: Date? {
		get {
			guard let start = data.first(where: { $0.name == "start" }) else {
				return nil
			}
			return start.data.dateValue
		}
		set(maybeValue) {
//			guard let newValue = maybeValue else {
//				// Catch this... throw an error (cannot set nil... or do we want to set nil, clear it out?)
//				return
//			}
			let newValue: Date = maybeValue ?? Date()
			let newTime = newValue.round(precision: minutes(5))

			guard var datum = data.first(where: { $0.name == "start" }) else {
				data.append(Datum(name: "start", data: .time(newTime)))
				return
			}
			datum.data = .time(newTime)
		}
	}

	var stop: Date? {
		get {
			guard let stop = data.first(where: { $0.name == "stop" }) else {
				return nil
			}
			return stop.data.dateValue
		}
		set(maybeValue) {
//			guard let newValue = maybeValue else {
//				// Catch this... throw an error (cannot set nil... or do we want to set nil, clear it out?)
//				return
//			}
			let newValue: Date = maybeValue ?? Date()
			let newTime = newValue.round(precision: minutes(5))

			guard var datum = data.first(where: { $0.name == "stop" }) else {
				data.append(Datum(name: "stop", data: .time(newTime)))
				return
			}
			datum.data = .time(newTime)
		}
	}
}

extension DailyAnnotation {
	static var testDatum: [Datum] {
		[
			Datum(name: "start", data: .time(
				Date().floor(precision: minutes(5))
			)),
			Datum(name: "stop", data: .time(
				Date().ceil(precision: minutes(5)).addingTimeInterval(minutes(10))
			))
		]
	}
	
	static var testData: [DailyAnnotation] {
		[
			DailyAnnotation(data: testDatum)
		]
	}
}
