//
//  DateFormatter+formatter.swift
//  golOS
//
//  Created by Felix Akira Green on 1/3/21.
//

import Foundation

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

	static let mediumDateTimeFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateStyle = .medium
		df.timeStyle = .medium

		return df
	}()
}
