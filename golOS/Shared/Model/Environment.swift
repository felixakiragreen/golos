//
//  Environment.swift
//  golOS
//
//  Created by Felix Akira Green on 2/15/21.
//

import SwiftUI

struct TemporalViz {
	
	var contentSize: CGFloat
	var hoursInView: CGFloat = 24
	var _minuteSize: CGFloat {
		contentSize / hoursInView / 60
	}
	
	init() {
		self.contentSize = UIScreen.main.bounds.height
	}
	
	init(contentSize: CGFloat) {
		self.contentSize = contentSize
	}
}

struct TemporalVizEnvKey: EnvironmentKey {
	static var defaultValue: TemporalViz = TemporalViz()
}

extension EnvironmentValues {
	var temporalViz: TemporalViz {
		get { self[TemporalVizEnvKey.self] }
		set { self[TemporalVizEnvKey.self] = newValue }
	}
}

struct TemporalConfig {
	@Environment(\.calendar) var calendar
	
	var currentTime: Date
	
	// start of the day
	var currentDay: Date {
		calendar.startOfDay(for: currentTime)
	}
	var firstDay: Date {
		calendar.date(
			byAdding: .day, value: -1, to: currentDay
		)!
	}
	
	// rounded to hour
	var currentHour: Date {
		currentTime.floor(precision: minutes(60))
	}
	
	var rangeUnit: Calendar.Component = .hour
	var rangeValue: Int = 36
	
	
	var startTime: Date {
		calendar.date(
			byAdding: rangeUnit, value: -(rangeValue), to: currentHour
		)!
	}
	
	// currentHour - rangeInHours → rounded to hour
	var startHour: Date {
		calendar.date(
			byAdding: rangeUnit, value: -(rangeValue + 1), to: currentHour
		)!
	}
	// currentHour + rangeInHours → rounded to hour
	var endHour: Date {
		calendar.date(
			byAdding: rangeUnit, value: rangeValue + 1, to: currentHour
		)!
	}
	
	var hours: [Date] {
		calendar.generate(
			inside: DateInterval(start: startHour, end: endHour),
			matching: DateComponents(minute: 0, second: 0)
		)
	}
	
	init(currentTime: Date) {
		self.currentTime = currentTime
	}
}
