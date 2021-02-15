//
//  Environment.swift
//  golOS
//
//  Created by Felix Akira Green on 2/15/21.
//

import SwiftUI

// MARK: - TEMPORAL

struct TemporalSpec {
	
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

struct TemporalSpecEnvKey: EnvironmentKey {
	static var defaultValue: TemporalSpec = TemporalSpec()
}

extension EnvironmentValues {
	var temporalSpec: TemporalSpec {
		get { self[TemporalSpecEnvKey.self] }
		set { self[TemporalSpecEnvKey.self] = newValue }
	}
}

// MARK: - PHYSICAL

struct PhysicalSpec {
	var lat: Double = 39.856672
	var lng: Double = -86.132480
}

struct PhysicalSpecEnvKey: EnvironmentKey {
	static var defaultValue: PhysicalSpec = PhysicalSpec()
}

extension EnvironmentValues {
	var physicalSpec: PhysicalSpec {
		get { self[PhysicalSpecEnvKey.self] }
		set { self[PhysicalSpecEnvKey.self] = newValue }
	}
}

// MARK: - SOLAR

typealias SolarMoment = (time: Date, name: String)

typealias SolarInterval = (interval: DateInterval, name: String)


struct SolarSpec {
	@Environment(\.calendar) var calendar: Calendar
	@Environment(\.physicalSpec) var location: PhysicalSpec
	
	var sunCalc: SunCalc = SunCalc()
	
	func getTimesFor(date: Date) -> [String: Date] {
		return sunCalc.getTimes(date: date, lat: location.lat, lng: location.lng)
	}
	
	func getTimesFor(date: Date, range: [Int]) -> [SolarMoment] {
		var accTimes: [(time: Date, name: String)] = []
		
		for day in range {
			let dateValue = calendar.date(
				byAdding: .day, value: day, to: date
			)!
			let times = getTimesFor(date: dateValue)
			for (name, time) in times {
				accTimes.append((time, name))
			}
		}
		
		accTimes.sort { $0.time < $1.time }
		
		return accTimes
	}
	
	func getIntervalsFor(times: [SolarMoment], names: [String]) -> [SolarInterval] {
		var accIntervals: [SolarInterval] = []
		
		let namedTimes = times.filter { names.contains($0.name) }
		
		for index in namedTimes.indices {
			if index + 2 < namedTimes.count {
				let thisTime = namedTimes[index]
				let nextTime = namedTimes[index + 1]
				
				accIntervals.append((
					interval: DateInterval(start: thisTime.time, end: nextTime.time),
					name: thisTime.name
				))
			}
		}
		
		return accIntervals
	}
}

struct SolarSpecEnvKey: EnvironmentKey {
	static var defaultValue: SolarSpec = SolarSpec()
}

extension EnvironmentValues {
	var solarSpec: SolarSpec {
		get { self[SolarSpecEnvKey.self] }
		set { self[SolarSpecEnvKey.self] = newValue }
	}
}

