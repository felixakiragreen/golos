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
	var rangeUnit: Calendar.Component = .hour
	var rangeTotal: Int = 64
	var rangeInView: CGFloat = 16
	var _minuteSize: CGFloat {
		contentSize / rangeInView / 60
	}
	var _scrollSize: CGFloat {
		contentSize / rangeInView * CGFloat(rangeTotal)
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

// MARK: - DEBUG

struct DebugSpec {
	var dev: Bool = true
}

struct DebugSpecEnvKey: EnvironmentKey {
	static var defaultValue: DebugSpec = DebugSpec()
}

extension EnvironmentValues {
	var debugSpec: DebugSpec {
		get { self[DebugSpecEnvKey.self] }
		set { self[DebugSpecEnvKey.self] = newValue }
	}
}


