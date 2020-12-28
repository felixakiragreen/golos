//
//  Calendar2.swift
//  golOS layout
//
//  Created by Felix Akira Green on 12/13/20.
//

import SwiftUI

private extension DateFormatter {
	static var month: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM"
		return formatter
	}

	static var monthAndYear: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMMM yyyy"
		return formatter
	}
}

private extension Calendar {
	func generateDates(
		inside interval: DateInterval,
		matching components: DateComponents
	) -> [Date] {
		var dates: [Date] = []
		dates.append(interval.start)
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

struct CalendarView2<DateView>: View where DateView: View {
	@Environment(\.calendar) var calendar
	let interval: DateInterval
	let showHeaders: Bool
	let content: (Date) -> DateView
	init(
		interval: DateInterval,
		showHeaders: Bool = true,
		@ViewBuilder content: @escaping (Date) -> DateView
	) {
		self.interval = interval
		self.showHeaders = showHeaders
		self.content = content
		months = calendar.generateDates(
			inside: interval,
			matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
		)
		for month in months {
			if showHeaders {
				monthHeaders += [header(for: month)]
			}
			monthToDays[month] = days(for: month)
		}
	}

	var body: some View {
		LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
			ForEach(Array(months.enumerated()), id: \.offset) { index, month in
				Section(header: headerView(for: monthHeaders[index])) {
					if let days = monthToDays[month] {
						ForEach(days, id: \.self) { date in
							if calendar.isDate(date, equalTo: month, toGranularity: .month) {
								content(date).id(date)
							} else {
								content(date).hidden()
							}
						}
					}
				}
			}
		}
	}

	private var months = [Date]()
	private var monthHeaders = [String]()
	private var monthToDays = [Date: [Date]]()
	// Important: dont add padding or any frame modifications to the headerView or you will get performance issues
	private func headerView(for month: String) -> some View {
		Text(month)
			.font(.title)
	}

	private func header(for month: Date) -> String {
		let component = calendar.component(.month, from: month)
		let formatter = component == 1 ? DateFormatter.monthAndYear : .month
		return formatter.string(from: month)
	}

	private func days(for month: Date) -> [Date] {
		guard
			let monthInterval = calendar.dateInterval(of: .month, for: month),
			let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
			let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
		else { return [] }
		return calendar.generateDates(
			inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
			matching: DateComponents(hour: 0, minute: 0, second: 0)
		)
	}
}

struct CalendarView2_Previews: PreviewProvider {
	static var previews: some View {
		CalendarView2(interval: .init()) { _ in
			Text("30")
				.padding(8)
				.background(Color.blue)
				.cornerRadius(8)
		}
	}
}
