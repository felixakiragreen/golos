//
//  SolarModel.swift
//  golOS
//
//  Created by Felix Akira Green on 2/15/21.
//

import SwiftUI

typealias SolarMoment = (time: Date, name: String)

typealias SolarInterval = (interval: DateInterval, name: String)

class SolarModel: ObservableObject {
	@Environment(\.calendar) var calendar: Calendar
	@Environment(\.physicalSpec) var location: PhysicalSpec
	
	var sunCalc: SunCalc = SunCalc()
	
	var focal: Date
	var solarTimes: [SolarMoment]
	var focalPoints: [SolarMoment]
	var focalBlocks: [SolarInterval]

	init(date: Date) {
		self.focal = date
		self.solarTimes = []
		self.focalPoints = []
		self.focalBlocks = []
		
		reinit(date: date)
	}
	
	convenience init() {
		self.init(date: Date())
	}
	
	func reinit(date: Date) {
		self.focal = calendar.startOfDay(for: date)

		let solarTimes = getTimesFor(date: date, range: dayRange)
		self.solarTimes = solarTimes
		self.focalPoints = solarTimes.filter { pointNames.contains($0.name) }
		self.focalBlocks = getIntervalsFor(times: solarTimes, names: blockNames)
	}
	
	let dayRange = [
		-1, 0, 1, 2, 3
	]
	let pointNames = [
		"nadir", "solarNoon",
		"sunrise", "sunsetStart",
	]
	let blockNames = [
		"night", "nightEnd",
		"nauticalDawn", "dawn",
		"sunriseEnd", "goldenHourEnd",
		"goldenHour", "sunset",
		"dusk", "nauticalDusk",
	]
	
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
