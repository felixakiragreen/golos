//
//  SolarView.swift
//  golOS (iOS)
//
//  Created by Felix Akira Green on 1/5/21.
//

import SwiftUI

// MARK: - PREVIEW

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			MapView()
		}
		.preferredColorScheme(.dark)
	}
}

struct MapView: View {
	@Environment(\.calendar) var calendar
	
	@State private var mapTimeConfig: MapTimeConfig = MapTimeConfig(Date())
	let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

	var body: some View {
		// TODO: I'll need to make this continually updating
//		let tday = Date().round(precision: minutes(60))
//		let yday = calendar.date(
//			byAdding: .hour, value: -36, to: tday
//		)!
//		let tmrw = calendar.date(
//			byAdding: .hour, value: 36, to: tday
//		)!
		let hours: [Date] = calendar.generate(
			inside: DateInterval(start: mapTimeConfig.startTime, end: mapTimeConfig.endTime),
			matching: DateComponents(minute: 0, second: 0)
		)
		
		let tdayTime = DateFormatter.timeFormatter.string(from: mapTimeConfig.thisHour)
		let tdayHour = DateFormatter.timeFormatter.string(from: mapTimeConfig.thisTime)

		ZStack(alignment: .top) {
			GeometryReader { geometry in
				let height = geometry.size.height
//				let width = (geometry.size.width - 100) / 2
				let hourHeight: CGFloat = round(height / 24)

				let nowSeconds = CGFloat(mapTimeConfig.thisTime.timeIntervalSince(mapTimeConfig.startTime) - minutes(60))
				let nowOffsetY = hourHeight * (nowSeconds / 60 / 60)
				
				let cursorOffsetY = CGFloat(height * 0.618)

				ScrollView {
					ZStack(alignment: .top) {
						VStack {
							ForEach(hours, id: \.self) { h in
//								let hSeconds = CGFloat(h.timeIntervalSince(yday))
//								let hOffsetY = hourHeight * (hSeconds / 60 / 60)

								let time = DateFormatter.hourFormatter.string(from: h)
								HStack {
									Spacer()
									Text(time)
									Spacer()
								}
								.frame(height: hourHeight)
								//							.offset(x: 0, y: hOffsetY)
								.background(
									Hexagon()
										.foregroundColor(Color("grey.sys.400"))
								)
								.overlay(
									Rectangle()
										.frame(maxWidth: .infinity, maxHeight: 1)
										.foregroundColor(.secondary),
									alignment: .top
								)
							}
						}//: VStack
						
						// NOW rectangle
						Rectangle()
							.frame(maxWidth: .infinity, maxHeight: 2)
							.foregroundColor(Color("red.sys.600"))
							.offset(x: 0, y: nowOffsetY)
//						Text(tdayTime)
						
					}//: ZStack
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
					.onReceive(timer) { _ in
						self.mapTimeConfig = MapTimeConfig(Date())
					}
					
					
				} //: ScrollView

				// Cursor
				Rectangle()
					.frame(maxWidth: .infinity, maxHeight: 2)
					.foregroundColor(Color("green.sys.600"))
					.offset(x: 0, y: cursorOffsetY)
				
				Button("asdf") {
					print(hourHeight)
					print(nowOffsetY)
				}
				
			} //: GeometryReader
		} //: ZStack
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.navigationTitle("\(tdayTime) - \(tdayHour)")
//		.navigationBarItems(trailing: HStack {
//
//		})
	}
}


struct MapTimeConfig {
	@Environment(\.calendar) var calendar
	
	var thisTime: Date
	
	// rounded to hour
	var thisHour: Date {
		thisTime.round(precision: minutes(60))
	}
	
	var rangeUnit: Calendar.Component = .hour
	var rangeValue: Int = 36
	
	// thisHour - rangeInHours → rounded to hour
	var startTime: Date {
		calendar.date(
			byAdding: rangeUnit, value: -rangeValue, to: thisHour
		)!
	}
	// thisHour + rangeInHours → rounded to hour
	var endTime: Date {
		calendar.date(
			byAdding: rangeUnit, value: rangeValue, to: thisHour
		)!
	}

	init(_ thisTime: Date) {
		self.thisTime = thisTime
	}
}
