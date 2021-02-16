//
//  SolarModel.swift
//  golOS
//
//  Created by Felix Akira Green on 2/15/21.
//

import SwiftUI

typealias SolarMoment = (time: Date, name: String)

typealias SolarInterval = (interval: DateInterval, name: String)

typealias SolarPhase = (label: SolarLabel, interval: DateInterval)

class SolarModel: ObservableObject {
	@Environment(\.calendar) var calendar: Calendar
	@Environment(\.physicalSpec) var location: PhysicalSpec
	
	var sunCalc: SunCalc = SunCalc()
	
	var focal: Date
	var solarTimes: [SolarMoment]
	var focalPoints: [SolarMoment]
	var focalBlocks: [SolarInterval]
	var focalPhases: [SolarPhase]

	init(date: Date) {
		self.focal = date
		self.solarTimes = []
		self.focalPoints = []
		self.focalBlocks = []
		self.focalPhases = []
		
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
		
		self.focalPhases = getPhasesFor(times: solarTimes, labels: phaseNames)
	}
	
	let dayRange = [
		-1, 0, 1, 2, 3
	]
	let pointNames = [
		"nadir", // NADIR
		"solarNoon", // NOON
		"sunrise", // SUNRISE
		"sunsetStart", // SUNSET
	]
	let blockNames = [
		"night", // night
		"nightEnd", // astro.dawn
		"nauticalDawn", // nauty.dawn
		"dawn", // civie.dawn
		"sunriseEnd", // goldy.dawn
		"goldenHourEnd", // day
		"goldenHour", // goldy.dusk
		"sunset", // civie.dusk
		"dusk", // nauty.dusk
		"nauticalDusk", // astro.dusk
	]
	let phaseNames: [SolarLabel] = [
		.night,
		.astroDawn,
		.civieDawn,
		.goldyDawn,
		.day,
		.goldyDusk,
		.civieDusk,
		.nautyDusk
	]
	
	func getTimesFor(date: Date) -> [String: Date] {
		sunCalc.getTimes(date: date, lat: location.lat, lng: location.lng)
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
	
	func getPhasesFor(times: [SolarMoment], labels: [SolarLabel]) -> [SolarPhase] {
		var accPhases: [SolarPhase] = []

		let names = labels.map { $0.rawValue }
		
		let intervals = getIntervalsFor(times: times, names: names)
		
		for block in intervals {
			if let label = SolarLabel(rawValue: block.name) {
				accPhases.append((
					label: label,
					interval: block.interval
				))
			}
		}
		
		return accPhases
	}
	
	func getPhaseProgressFor(time: Date) -> SolarPhaseProgress? {
		if let insidePhase = focalPhases.first(where: { $0.interval.contains(time) }) {
			let timeElapsed = insidePhase.interval.start.distance(to: time)
			let progress = timeElapsed / insidePhase.interval.duration
			
			switch insidePhase.label {
				case .night: return .night(fadeInOut(progress))
				case .astroDawn: return .dawn(fadeOut(progress))
				case .civieDawn: return .rise(fadeHold(progress))
				case .goldyDawn: return .shine(fadeIn(progress))
				case .day: return .day(fadeInOut(progress))
				case .goldyDusk: return .shine(fadeIn(1 - progress))
				case .civieDusk: return .set(fadeHold(progress))
				case .nautyDusk: return .dusk(fadeOut(progress))
				default: return nil
			}
		}
		return nil
	}
}

let transitionCutoff = 0.5

func fadeInOut(_ progress: TimeInterval) -> Double {
	let cutoff = 0.3
	if progress <= cutoff {
		return progress / cutoff
	} else if progress >= 1 - cutoff {
		return (1 - progress) / cutoff
	} else {
		return 1
	}
}

func fadeOut(_ progress: TimeInterval) -> Double {
	let cutoff = 1.0
	if progress >= 1 - cutoff {
		return 1 - ((1 - progress) / cutoff)
	} else {
		return 0
	}
}

func fadeIn(_ progress: TimeInterval) -> Double {
	let cutoff = 1.0
	if progress <= cutoff {
		return progress / cutoff
	} else {
		return 1
	}
}

func fadeHold(_ progress: TimeInterval) -> Double {
	return 1
}

enum SolarPhaseProgress {
	case night(Double), day(Double) // 0.0 start, 1.0 middle, 0.0 end
	case dawn(Double), rise(Double), set(Double), dusk(Double) // 0.0 start, 1.0 end
	case shine(Double) // 0.0 night, 1.0 day
}

enum SolarLabel: String {
	case nadir = "nadir"
	case night = "night"

	case astroDawn = "nightEnd"
	case nautyDawn = "nauticalDawn"
	case civieDawn = "dawn"
	case sunrise = "sunrise"
	case goldyDawn = "sunriseEnd"
	
	case day = "goldenHourEnd"
	case noon = "solarNoon"
	
	case goldyDusk = "goldenHour"
	case sunset = "sunsetStart"
	case civieDusk = "sunset"
	case nautyDusk = "dusk"
	case astroDusk = "nauticalDusk"
}

func getSolarLabel(_ name: String) -> String {
	switch name {
		case "nadir": return "NADIR"
		case "night": return "night"
			
		case "nightEnd": return "astro.dawn"
		case "nauticalDawn": return "nauty.dawn"
		case "dawn": return "civie.dawn"
		case "sunrise": return "SUNRISE"
		case "sunriseEnd": return "goldy.dawn"
			
		case "goldenHourEnd": return "day"
		case "solarNoon": return "NOON"
			
		case "goldenHour": return "goldy.dusk"
		case "sunsetStart": return "SUNSET"
		case "sunset": return "civie.dusk"
		case "dusk": return "nauty.dusk"
		case "nauticalDusk": return "astro.dusk"
			
		default: return name
	}
}

func getSolarColor(_ name: String) -> ColorPreset {
	switch getSolarLabel(name) {
		case "night", "NADIR":
			return ColorPreset(hue: .blue, lum: .normal)
		case "day", "NOON":
			return ColorPreset(hue: .grey, lum: .normal)
		case "astro.dawn", "astro.dusk":
			return ColorPreset(hue: .purple, lum: .normal)
		case "nauty.dawn", "nauty.dusk":
			return ColorPreset(hue: .red, lum: .normal)
		case "civie.dawn", "civie.dusk":
			return ColorPreset(hue: .orange, lum: .normal)
		case "goldy.dawn", "goldy.dusk":
			return ColorPreset(hue: .yellow, lum: .normal)
		default:
			return ColorPreset(hue: .green, lum: .normal)
	}
}
