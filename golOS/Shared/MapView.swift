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

/**
 TODO:
 x - go to Now
 x - we need the offset
 x - haptics
 x - get cursor position
 x - move cursor with scrollview ?

 - abstract the scroll logic

 later:
 - make the overlay look pretty (separate component)
 - snap to hours when scrolling

  */

struct MapView: View {
	@Environment(\.calendar) var calendar

	@State private var mapTimeConfig = MapTimeConfig(Date())
	let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

	@State var scrollOffset: CGFloat = .zero
	@State var intervalHeight: CGFloat = round(UIScreen.main.bounds.size.height / 24)
	var snapIncrement: CGFloat {
		intervalHeight
	}
	
	var scrollHeight: CGFloat {
		let totalIntervals = mapTimeConfig.rangeValue * 2 + 1
		return snapIncrement * CGFloat(totalIntervals)
//		print("totalIntervals →", totalIntervals)
//		return CGFloat(totalIntervals) * snapIncrement
	}
	
	var containedScrollOffset: CGFloat {
		if abs(scrollOffset) == .zero {
			return .zero
		}
//		let totalIntervals = mapTimeConfig.rangeValue * 2 + 1
//		print("totalIntervals →", totalIntervals)
//		let scrollHeight: CGFloat = CGFloat(totalIntervals) * snapIncrement
//		let scrollHeight = CGFloat
//		print("scrollHeight →", scrollHeight)
//		let value = clamp(value: scrollOffset * -1, lower: 0, upper: scrollHeight)
		
//		return abs(scrollOffset)
		
//		TODO: fix / remove the -1
		let upper = scrollHeight - scrollContainerHeight - 1
		
		return clamp(value: scrollOffset * -1, lower: 0, upper: upper)
	}
	
	var scrollSnap: CGFloat {
//		print("containedScrollOffset → ", containedScrollOffset)
		if containedScrollOffset == .zero {
			return .zero
		}
		let snap = CGFloat(round(containedScrollOffset / snapIncrement) * snapIncrement)
//		print(snap)
		return snap
	}
	
	//	TODO: FIX SO THIS ISN'T ABSOLUTE
	var scrollContainerHeight: CGFloat {
		if scrollOffset < -52 {
			return CGFloat(684)
		}
		return CGFloat(632)
	}
	var cursorRelativePosition: CGFloat {
//		let totalIntervals = mapTimeConfig.rangeValue * 2 + 1
//		print("totalIntervals →", totalIntervals)
//		let scrollHeight: CGFloat = CGFloat(totalIntervals) * snapIncrement
//		print("scrollHeight →", scrollHeight)
		
//		let screenHeight = UIScreen.main.bounds.size.height
//		print("screenHeight →", screenHeight)
		
//		print("scrollHeight →", scrollHeight)
//		print("containedScrollOffset →", containedScrollOffset)
		
		let outOf = scrollHeight - scrollContainerHeight
//		print("outOf →", outOf)
//		let clampedOff
		
		let percentageThrough = min((containedScrollOffset / outOf), 1)
		print("percentage", percentageThrough)
		
//		(scrollHeight - min(containedScrollOffset, outOf))
		
		let position = scrollContainerHeight * percentageThrough
//		print("position", position)
		
		return CGFloat(position)
	}
	var cursorRelativeSnappingIncrement: CGFloat {
		return CGFloat(round(cursorRelativePosition / snapIncrement) * snapIncrement)
	}
	
	var cursorOffset: CGFloat {
		containedScrollOffset + cursorRelativePosition
	}
	var cursorSnap: CGFloat {
		scrollSnap + cursorRelativeSnappingIncrement
	}
	var cursorInterval: Int {
		Int((cursorOffset / snapIncrement)) + 1
	}
	var cursorTime: Date {
		return calendar.date(
			byAdding: mapTimeConfig.rangeUnit, value: cursorInterval, to: mapTimeConfig.startTime
		)!
	}

	var body: some View {
		let hours: [Date] = calendar.generate(
			inside: DateInterval(start: mapTimeConfig.startTime, end: mapTimeConfig.endTime),
			matching: DateComponents(minute: 0, second: 0)
		)

//		let tdayTime = DateFormatter.timeFormatter.string(from: mapTimeConfig.thisHour)
//		let tdayHour = DateFormatter.timeFormatter.string(from: mapTimeConfig.thisTime)
		let cursorHour = DateFormatter.dayHourFormatter.string(from: cursorTime)

//		let impactMed = UIImpactFeedbackGenerator(style: .medium)

		GeometryReader { geometry in
			ScrollViewReader { scrollProxy in
				ZStack(alignment: .top) {
//					let height = geometry.size.height
					let screenHeight = UIScreen.main.bounds.size.height
//
//				let width = (geometry.size.width - 100) / 2
					let hourHeight = round(screenHeight / 24)

					let nowSeconds = CGFloat(mapTimeConfig.thisTime.timeIntervalSince(mapTimeConfig.startTime) - minutes(60))
					let nowOffsetY = hourHeight * (nowSeconds / 60 / 60)

//					let cursorOffsetY = CGFloat(height * 0.618)
//					let cursorOffsetY = scrollSnap

					ScrollViewOffset {
						scrollOffset = $0
//						print("height", height)

//						let thingies = scrollOffset.truncatingRemainder(dividingBy: hourHeight)
//					abs(
//						print(thingies)

//					if thingies == 0 {
//						impactMed.impactOccurred()
//					}
					} content: {
						ZStack(alignment: .top) {
							VStack {
								ForEach(hours, id: \.self) { h in
//								let hSeconds = CGFloat(h.timeIntervalSince(yday))
//								let hOffsetY = hourHeight * (hSeconds / 60 / 60)

									let time = DateFormatter.dayHourFormatter.string(from: h)
									let isUnderCursor = time == cursorHour
									
									HStack {
										Spacer()
										Text(time)
										Spacer()
									}
									.id("\(time)")
									.frame(height: hourHeight)
									//							.offset(x: 0, y: hOffsetY)
									.background(
										Hexagon()
											.foregroundColor(isUnderCursor ? Color("grey.sys.600") : Color("grey.sys.400"))
									)
									.overlay(
										Rectangle()
											.frame(maxWidth: .infinity, maxHeight: 1)
											.foregroundColor(.secondary),
										alignment: .top
									)
								}
							} //: VStack

							// NOW rectangle
							Rectangle()
								.frame(maxWidth: .infinity, maxHeight: 2)
								.foregroundColor(Color("red.sys.600"))
								.offset(x: 0, y: nowOffsetY)
							
							// Cursor Offset
							Rectangle()
								.frame(maxWidth: .infinity, maxHeight: 2)
								.foregroundColor(Color("green.sys.600"))
								.offset(x: 0, y: cursorOffset)
							
							// Cursor Snap
							Rectangle()
								.frame(maxWidth: .infinity, maxHeight: 2)
								.foregroundColor(Color("blue.sys.600"))
								.offset(x: 0, y: cursorSnap)
							
//						Text(tdayTime)
						} //: ZStack
						.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
						.onAppear {
//							print("onAppear → ", height)
						////							intervalHeight = round(height / 24)
							let now = DateFormatter.dayHourFormatter.string(from: mapTimeConfig.thisHour)
							withAnimation {
								scrollProxy.scrollTo("\(now)", anchor: UnitPoint(x: 0.5, y: 0.51))
							}
						}
//						.onChange(of: height) { height in
//							print("onChange → height:", height)
//							print("screenHeight:", screenHeight)
////							intervalHeight = round(screenHeight / 24)
////							cursorOffset = intervalHeight * 5
////							print("onChange → intervalHeight:", intervalHeight)
////							print("onChange → intervalHeight:", cursorOffset)
//						}
						.onReceive(timer) { _ in
							self.mapTimeConfig = MapTimeConfig(Date())
						}
						.onChange(of: scrollSnap) { [scrollSnap] newValue in
							print("old", scrollSnap)
							print("new", newValue)
							//
							let impactMed = UIImpactFeedbackGenerator(style: .medium)

							if newValue != scrollSnap {
								// TODO: to make it every 4 hours
//								if abs(newValue.truncatingRemainder(dividingBy: snapIncrement * 4)) == 0 {
								impactMed.impactOccurred()
//								}
							}
						}
					} //: ScrollView

					Button("Go To Now") {
						print(hourHeight)
						print(nowOffsetY)
						let now = DateFormatter.dayHourFormatter.string(from: mapTimeConfig.thisHour)
						withAnimation {
							scrollProxy.scrollTo("\(now)", anchor: UnitPoint(x: 0.5, y: 0.51))
						}
					}
					.padding()
					.background(
						Color("grey.sys.300")
					)
					
					
				} //: ZStack
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//				.navigationTitle("\(tdayTime) - \(tdayHour) → \(scrollOffset, specifier: "%.f"), \(scrollSnap, specifier: "%.f")")
				.navigationTitle("\(cursorHour)")
			} //: ScrollViewReader
		} //: GeometryReader
	}
}

struct MapTimeConfig {
	@Environment(\.calendar) var calendar

	var thisTime: Date

	// rounded to hour
	var thisHour: Date {
		thisTime.floor(precision: minutes(60))
	}

	var rangeUnit: Calendar.Component = .hour
	var rangeValue: Int = 36

	// thisHour - rangeInHours → rounded to hour
	var startTime: Date {
		calendar.date(
			byAdding: rangeUnit, value: -(rangeValue + 1), to: thisHour
		)!
	}

	// thisHour + rangeInHours → rounded to hour
	var endTime: Date {
		calendar.date(
			byAdding: rangeUnit, value: rangeValue + 1, to: thisHour
		)!
	}

	init(_ thisTime: Date) {
		self.thisTime = thisTime
	}
}


///Returns the input value clamped to the lower and upper limits.
func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
	return min(max(value, lower), upper)
}
