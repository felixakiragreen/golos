//
//  Calendar+generate.swift
//  FutureUI
//
//  Created by Felix Akira Green on 1/8/21.
//

import Foundation

extension Calendar {
	func generate(
		inside interval: DateInterval,
		matching components: DateComponents
	) -> [Date] {
		var dates: [Date] = []

		enumerateDates(
			startingAfter: interval.start,
			matching: components,
			matchingPolicy: .nextTime
		) { date, _, stop in
			if let date = date {
				if date < interval.end {
					dates.append(date)
				} else {
					stop = true
				}
			}
		}

		return dates
	}
}
