//
//  TimelineCoordinatesView.swift
//  golOS layout
//
//  Created by Felix Akira Green on 12/13/20.
//

import SwiftUI

/*
 TODO:
 - take some "bounds"
 - map it horizontally
 - show right now
 */

struct TimelineCoordinatesView: View {
	// MARK: - PROPS

	let startDate = Calendar.current.date(
		byAdding: DateComponents(calendar: Calendar.current, day: -1), to: Date()
	)
	let endDate = Calendar.current.date(
		byAdding: DateComponents(calendar: Calendar.current, day: 1), to: Date()
	)

	var bounds: DateInterval {
		return DateInterval(start: startDate ?? Date(), end: endDate ?? Date())
	}

	// MARK: - BODY

	var body: some View {
		VStack {
			HStack {
				Text("hey")
			}
			HStack {
				
			} //: HSTACK
			.frame(maxWidth: .infinity, maxHeight: .infinity)
		} //: VSTACK
	}
}

// MARK: - PREVIEW

struct TimelineCoordinatesView_Previews: PreviewProvider {
	static var previews: some View {
		TimelineCoordinatesView()
	}
}

// MARK: - UNITS

enum TimeUnit: Int {
	case pentaminute = 5
	case decaminute = 10
	case quarterhour = 15
	case icosaminute = 20
	case halfhour = 30
	case hour = 60
	case dihour = 120
	case tetrahour = 240
	case hexahour = 360
	case octahour = 480
	case halfday = 720
	case day = 1440

	// TODO: add week, month, year, pentad, decade, quarter cent, half cent, cent
}

// TODO: this might get refactored/abstracted out
struct ZoomingUnits {
	var space: TimeUnit
	var nano: TimeUnit?
	var micro: TimeUnit?
	var mezzo: TimeUnit?
	var major: TimeUnit?

	//	init(
	// TODO: insert guards requiring nano < micro < mezzo < major
}

struct IntervalConfig {
	var unit: TimeUnit // smallest unit of precision
	var count: Int // number of units
	var radius: CGFloat // width of the smallest unit
	var spacing: CGFloat? = 0
}
