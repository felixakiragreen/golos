//
//  Calendar+numberOf.swift
//  FutureUI
//
//  Created by Felix Akira Green on 2/5/21.
//

import Foundation

extension Calendar {
	func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
		let fromDate = startOfDay(for: from)
		let toDate = startOfDay(for: to)
		let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
		
		return numberOfDays.day!
	}
}

extension Calendar {
	func numberOfHoursBetween(_ from: Date, and to: Date) -> Int {
		let numberOfHours = dateComponents([.hour], from: from, to: to)
		
		return numberOfHours.hour!
	}
}
