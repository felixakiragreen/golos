//
//  Date+round.swift
//  golOS
//
//  Created by Felix Akira Green on 1/3/21.
//

import SwiftUI

extension Date {
	func round(precision: TimeInterval) -> Date {
		return round(precision: precision, rule: .toNearestOrAwayFromZero)
	}

	func ceil(precision: TimeInterval) -> Date {
		return round(precision: precision, rule: .up)
	}

	func floor(precision: TimeInterval) -> Date {
		return round(precision: precision, rule: .down)
	}

	private func round(precision: TimeInterval, rule: FloatingPointRoundingRule) -> Date {
		let seconds = (timeIntervalSinceReferenceDate / precision).rounded(rule) * precision
		return Date(timeIntervalSinceReferenceDate: seconds)
	}
}

func minutes(_ min: Double) -> TimeInterval {
	return 60 * min
}
