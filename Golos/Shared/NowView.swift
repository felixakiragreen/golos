//
//  NowView.swift
//  Golos
//
//  Created by Felix Akira Green on 11/7/20.
//

import SwiftUI

struct NowView: View {
	@State var selectedDate: Date = Date()
	
	var body: some View {
		HStack(spacing: 32.0) {
			DisplayHumanEraYear(date: selectedDate)
			DisplayQuarter(date: selectedDate)
			DisplayMonth(date: selectedDate)
			DisplayWeek(date: selectedDate)
			DisplayDay(date: selectedDate)
		}
		.font(.largeTitle)
	}
}

struct DisplayHumanEraYear: View {
	let date: Date
	
	var body: some View {
		Label {
			Text("1 \(date, formatter: Self.yearFormatter)")
		} icon: {
			HStack(spacing: 0.0) {
				Image(systemName: "h.circle")
				Image(systemName: "e.circle")
			}
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
	
	var body: some View {
		let quarter = Self.quarterFormatter.string(from: date)
		
//		TODO: add my seasons with emojis and custom ranges
//		let season =
		
		Label {
			Text("\(quarter)")
		} icon: {
			Image(systemName: "q.circle")
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
	
	var body: some View {
		Label {
			Text("\(date, formatter: Self.monthFormatter)")
		} icon: {
			Image(systemName: "m.circle")
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
	
	var body: some View {
		Label {
			Text("\(date, formatter: Self.weekFormatter)")
		} icon: {
			Image(systemName: "w.circle")
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
	
	var body: some View {
		Label {
			Text("\(date, formatter: Self.dayFormatter)")
		} icon: {
			Image(systemName: "d.circle.fill")
		}
	}
	
	static let dayFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.setLocalizedDateFormatFromTemplate("d")
		
		return formatter
	}()
}

struct NowView_Previews: PreviewProvider {
	static var previews: some View {
		NowView()
	}
}
