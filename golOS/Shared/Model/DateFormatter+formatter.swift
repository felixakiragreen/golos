//
//  DateFormatter+formatter.swift
//  golOS
//
//  Created by Felix Akira Green on 1/3/21.
//

import Foundation

// TODO: rework

extension DateFormatter {
	static let mediumDateFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateStyle = .medium
		df.timeStyle = .none

		return df
	}()

	static let mediumTimeFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateStyle = .none
		df.timeStyle = .medium

		return df
	}()

	static let hourFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "HH"

		return df
	}()
	
	static let timeFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "HH:mm"

		return df
	}()

//	func hourString(from date: Date) -> String {
//		return hourFormatter.string(from: date)
//	}

//	Text("\(previewTime, formatter: Self.timeFormatter)")

	static let mediumDateTimeFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateStyle = .medium
		df.timeStyle = .medium

		return df
	}()
}
