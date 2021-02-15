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

struct SolarSpec {
	@Environment(\.physicalSpec) var location: PhysicalSpec
	
	var sunCalc: SunCalc = SunCalc()
	
	func getTimes(date: Date) -> [String: Date] {
		return sunCalc.getTimes(date: date, lat: location.lat, lng: location.lng)
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

