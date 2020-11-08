//
//  DisplayDate.swift
//  Golos
//
//  Created by Felix Akira Green on 11/7/20.
//

import SwiftUI

struct DisplaySelectedDateView: View {
	let selectedDate: Date
	
	var body: some View {
		HStack(spacing: 16.0) {
			DisplayHumanEraYear(date: selectedDate)
			DisplayQuarter(date: selectedDate)
			DisplayWeek(date: selectedDate)
			DisplayMonth(date: selectedDate)
			DisplayDay(date: selectedDate)
		}
	}
}

struct DisplayHumanEraYear: View {
	let date: Date
	let spacing: CGFloat = 4.0
	
	var body: some View {
		HStack(spacing: spacing) {
			Text("he")
				.foregroundColor(.secondary)
			Text("1 \(date, formatter: Self.yearFormatter)")
		}
	}
	
	static let yearFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.setLocalizedDateFormatFromTemplate("y")
		
		return formatter
	}()
}

struct DisplayQuarter: View {
	let date: Date
	let spacing: CGFloat = 4.0
	
	var body: some View {
		let quarter = Self.quarterFormatter.string(from: date)
		
//		TODO: add my seasons with emojis and custom ranges
//		let season =
		
		HStack(spacing: spacing) {
			Text("q")
				.foregroundColor(.secondary)
			Text("\(quarter)")
		}
	}
	
	static let quarterFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.setLocalizedDateFormatFromTemplate("q")
		
		return formatter
	}()
}

struct DisplayMonth: View {
	let date: Date
	let spacing: CGFloat = 4.0
	
	var body: some View {
		HStack(spacing: spacing) {
			Text("m")
				.foregroundColor(.secondary)
			Text("\(date, formatter: Self.monthFormatter)")
		}
	}
	
	static let monthFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.setLocalizedDateFormatFromTemplate("MMM")
		
		return formatter
	}()
}

struct DisplayWeek: View {
	let date: Date
	let spacing: CGFloat = 4.0
		
	var body: some View {
		HStack(spacing: spacing) {
			Text("w")
				.foregroundColor(.secondary)
			Text("\(date, formatter: Self.weekFormatter)")
		}
	}
	
	static let weekFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.setLocalizedDateFormatFromTemplate("w")
		
		return formatter
	}()
}

struct DisplayDay: View {
	let date: Date
	let spacing: CGFloat = 4.0
		
	var body: some View {
		HStack(spacing: spacing) {
			Text("d")
				.foregroundColor(.secondary)
			Text("\(date, formatter: Self.dayFormatter)")
		}
	}
	
	static let dayFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.setLocalizedDateFormatFromTemplate("d")
		
		return formatter
	}()
}

struct DisplayDate_Previews: PreviewProvider {
	static let date = Date()

	static var previews: some View {
		DisplaySelectedDateView(selectedDate: date)
	}
}
