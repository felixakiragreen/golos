//
//  SolarView.swift
//  golOS
//
//  Created by Felix Akira Green on 2/14/21.
//

import SwiftUI

/**
# TODO:

## Scrollfixes:

- [ ] fix the rubberbanding
- [ ] fix the momentum, slow down...
- [ ] make it interruptible (interactiveSpring() I think?)
- [ ] make the times animate gradually

- add the horizon
- add the tick marks

- need to size the before & after correctly
OR decide do I do 72 hours or 3 days... HMMM

*/

// MARK: - PREVIEW
struct SolarView_Previews: PreviewProvider {
	
	static var height: CGFloat = (UIScreen.main.bounds.height - 44 - 34)
	
	static var previews: some View {
		SolarView(height: height)
	}
}

// let screenWidth = UIScreen.main.bounds.width


struct SolarView: View {
	// MARK: - PROPS

	@GestureState private var translation: CGSize = .zero
	
	@State private var offset: CGSize = .zero

	@State var scrollviewOffset: CGFloat = .zero
	
	// let screenHeight = UIScreen.main.bounds.height

	let height: CGFloat
	let hoursInView: CGFloat = 24
	var _minuteHeight: CGFloat {
		height / hoursInView / 60
	}
	
	var _scrollOffset: CGFloat {
		self.translation.height + self.offset.height
	}
	
	
	
	let today = Calendar.current.startOfDay(for: Date())
	var yday: Date {
		Calendar.current.date(
			byAdding: .day, value: -1, to: today
		)!
	}
	
	// MARK: - BODY
	var body: some View {
		ScrollViewReader { scrollProxy in
			ZStack {
				Color.pink.opacity(0.2).ignoresSafeArea()
				
				ScrollViewOffset {
					scrollviewOffset = $0
				} content: {
					
					ZStack(alignment: .top) {
						Color.clear
							// .frame(height: 0)
							.onAppear {
								scrollToNow(proxy: scrollProxy)
							}
						// Color.red.opacity(0.2).ignoresSafeArea()
						
						// VStack {
							// Spacer()
							// Color.red
						// }
						// .frame(maxWidth: .infinity, maxHeight: .infinity)
						// SunsetView(height: height)
						//
							// .offset(x: 0, y: -currentTimeOffset)
						// .frame(height: height)
						// .offset(x: 0, y: _scrollOffset)
						
						VStack(spacing: 0) {
							Rectangle()
								.fill(Color.red.opacity(0.1))
								.frame(height: height * 1.5)
							Rectangle()
								.fill(Color.red)
								.frame(maxWidth: .infinity, maxHeight: 2)
								.id("now")
							Rectangle()
								.fill(Color.red.opacity(0.1))
								.frame(height: height * 1.5)
								// .offset(x: 0, y: scrollviewOffset + currentTimeOffset)
						}
							
						
						ZStack {
							Circle()
								.fill(Color.gray.opacity(0.85))
								.frame(width: 150, height: 150)
								.shadow(radius: 8)
								.overlay(
									VStack {
										Text(currentTimeString)
										Text("\(scrollviewOffset, specifier: "%.1f")")
										Text(cursorTimeString)
									}
								)
								.onTapGesture {
									scrollToNow(proxy: scrollProxy)
								}
							
							Rectangle()
								.fill(Color.blue)
								.frame(maxWidth: .infinity, maxHeight: 2)
						}
						.frame(height: height)
						//Stay fixed because inverse of offset
						.offset(x: 0, y: -scrollviewOffset)

					}
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
					// .frame(height: height, alignment: .top)
					// .background(Color.orange.opacity(0.2))
					
						
				}
			}
			.background(Color.blue.opacity(0.2))
		}
		// .frame(height: height)
			
	}

	var drag: some Gesture {
		DragGesture()
			.updating($translation) { value, state, _ in
				state = value.translation
			}
			.onEnded { value in
				offset += value.translation
				withAnimation(.interactiveSpring(blendDuration: 2)) {
					offset += value.predictedEndTranslation - value.translation
					offset.height = clamp(value: offset.height, lower: -height, upper: height)
				}
			}
	}

	var currentTime: Date {
		Date().round(precision: minutes(5))
	}
	
	var currentTimeString: String {
		DateFormatter.bestTimeFormatter.string(from: currentTime)
	}
	
	var currentTimeOffset: CGFloat {
		let numberOfMinutes = Calendar.current.dateComponents(
			[.minute],
			from: yday,
			to: currentTime
		).minute ?? 0
		
		return CGFloat(numberOfMinutes) * _minuteHeight
	}
	
	var cursorTime: Date {
		let cursorOffset = height / 2
		// let cursorOffset = height * 0
		
		let minutesToAdd = (cursorOffset + scrollviewOffset * -1) / _minuteHeight
		
		return today
			.advanced(by: minutes(Double(minutesToAdd)))
			.round(precision: minutes(5))
	}
	
	var cursorTimeString: String {
		DateFormatter.bestTimeFormatter.string(from: cursorTime)
	}
	
	// scroll to goToNow()
	func scrollToNow(proxy: ScrollViewProxy) {
		// let cursorOffset = height / 2
		// maxWidth: .infinity, maxHeight: .infinity,
		
		// let scrollTo = (cursorOffset + _scrollOffset * -1) - currentTimeOffset
		
		withAnimation {
			// proxy.scrollTo("now", anchor: .center)
			proxy.scrollTo("now", anchor: UnitPoint(x: 0.5, y: 0.5))
			
			// self.offset += CGSize(width: 0, height: scrollTo)
		}
	}
}

struct SunsetView: View {

	// put into some kind of config??
	let height: CGFloat
	let hoursInView: CGFloat = 24
	var _minuteHeight: CGFloat {
		height / hoursInView / 60
	}

	var date: Date = Calendar.current.startOfDay(for: Date())
	let dayRange = [
		-1, 0, 1, 2, 3
	]
	var firstDate: Date {
		Calendar.current.date(
			byAdding: .day, value: dayRange[0], to: date
		)!
	}

	let Sun = SunCalc()
	
	var lat = 39.856672
	var lng = -86.132480

	let acceptedNames = [
		"night", "nadir", "nightEnd",
		"goldenHourEnd", "solarNoon", "goldenHour"
	]

	typealias SolarMoment = (time: Date, name: String)
	
	var solarTimes: [SolarMoment] {
		var allSolarTimes: [(time: Date, name: String)] = []
		
		for day in dayRange {
			let dateValue = Calendar.current.date(
				byAdding: .day, value: day, to: date
			)!
			let times = Sun.getTimes(date: dateValue, lat: lat, lng: lng)
			for (name, time) in times {
				allSolarTimes.append((time, name))
			}
		}
		
		allSolarTimes.sort { $0.time < $1.time }
		
		return allSolarTimes
	}
	
	typealias SolarInterval = (interval: DateInterval, name: String)
	var solarBlocks: [SolarInterval] {
		var intervals: [SolarInterval] = []
		
		let blockNames = [
			"night", "nightEnd",
			"goldenHourEnd", "goldenHour"
		]
		
		let blocks = solarTimes.filter { blockNames.contains($0.name) }
		
		for index in blocks.indices {
			if index + 2 < blocks.count {
				let thisTime = blocks[index]
				let nextTime = blocks[index + 1]
				
				intervals.append((
					interval: DateInterval(start: thisTime.time, end: nextTime.time),
					name: thisTime.name
				))
			}
		}
		
		return intervals
	}
	
	var solarPoints: [SolarMoment] {
		let pointNames = [
			"nadir", "solarNoon"
		]
		
		return solarTimes.filter { pointNames.contains($0.name) }
	}
	
	var body: some View {
		// let offset = (self.translation.height + self.offset.height)
		
		// .truncatingRemainder(dividingBy: screenHeight)
		
		ZStack(alignment: .top) {
			// LazyVStack(spacing: 0) {
			// 	DayCycle(label: "yday")
			// 		.frame(height: height)
			// 	DayCycle(label: "today")
			// 		.frame(height: height)
			// 	DayCycle(label: "tmrw")
			// 		.frame(height: height)
			// }
			// LazyVStack(spacing: 0) {
				ForEach(solarBlocks.indices) { index in
					let block = solarBlocks[index]
					let offset = getOffsetForTime(fromDate: firstDate, toTime: block.interval.start, minuteHeight: _minuteHeight)
					let height = CGFloat(block.interval.duration) / 60 * _minuteHeight
					let time = DateFormatter.shortFormatter.string(from: block.interval.start)
			//
					Rectangle()
						.fill(getSolarColor(block.name).getSecondaryColor())
						.frame(height: height)
						.overlay(
							VStack {
								HStack {
									Text("\(getSolarLabel(block.name))")
									Spacer()
									Text("\(offset, specifier: "%.1f")")
									Spacer()
									Text("\(time)")
									Spacer()
									Text("\(block.interval.duration / 60, specifier: "%.0f")min")
								}
								Spacer()
							}
						)
						.offset(x: 0, y: offset)
			//
				}
			// }
			ForEach(solarPoints.indices) { index in
				let moment = solarPoints[index]
				let offset = getOffsetForTime(fromDate: firstDate, toTime: moment.time, minuteHeight: _minuteHeight)
				let time = DateFormatter.shortFormatter.string(from: moment.time)
					
				Rectangle()
					.fill(getSolarColor(moment.name).getColor())
					.frame(height: 24)
					.overlay(
						HStack {
							Text("\(getSolarLabel(moment.name))")
							Spacer()
							Text("\(offset, specifier: "%.1f")")
							Spacer()
							Text("\(time)")
						}
					)
					.offset(x: 0, y: offset)
					
			}
			Text("asdf: \(solarTimes.count)")
		}
		.frame(height: height * 3, alignment: .top)
		// .onAppear {
		// 	print(solarTimes)
		// }
		// .ignoresSafeArea()
		// dayCycle
		// .offset(x: 0, y: offset > 0 ? -screenHeight : screenHeight)
		// .animation(nil)
		// }
		//
		
	}
}

struct DayCycle: View {
	let label: String
	
	// let screenHeight = UIScreen.main.bounds.height
	
	var body: some View {
		VStack(spacing: 0) {
			Color.white
				.overlay(
					Text(label)
						.font(.largeTitle)
				)
			Color.black
		}
	}
}


func getSolarColor(_ name: String) -> ColorPreset {
	switch name {
		case "night", "nadir":
			return ColorPreset(hue: .purple, lum: .normal)
		case "nightEnd":
			return ColorPreset(hue: .red, lum: .normal)
		case "goldenHourEnd", "solarNoon":
			return ColorPreset(hue: .yellow, lum: .normal)
		case "goldenHour":
			return ColorPreset(hue: .orange, lum: .normal)
		default:
			return ColorPreset(lum: .normal)
	}
}

func getSolarLabel(_ name: String) -> String {
	switch name {
		case "night", "nadir": return name
		case "nightEnd": return "dawn"
		case "goldenHourEnd": return "day"
		case "solarNoon": return "noon"
		case "goldenHour": return "dusk"
		default: return ""
	}
}

func getOffsetForTime(fromDate: Date, toTime: Date, minuteHeight: CGFloat) -> CGFloat {
	let numberOfMinutes = Calendar.current.dateComponents(
		[.minute],
		from: fromDate,
		to: toTime
	).minute ?? 0
	
	return CGFloat(numberOfMinutes) * minuteHeight
}
