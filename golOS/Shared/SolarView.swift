//
//  SolarView.swift
//  golOS
//
//  Created by Felix Akira Green on 2/14/21.
//

import SwiftUI

/*

Next steps:

- [ ] overlay a new view with colored gradients that changes based on the cursor position
- [ ] try adding the horizon

- [ ] different scales (8h visible, 12h on either side)


*/

// MARK: - PREVIEW
struct SolarView_Previews: PreviewProvider {

	static var previews: some View {
		GeometryReader { geometry in
			SolarView()
				.environment(\.temporalSpec, TemporalSpec(contentSize: geometry.size.height))
		}
	}
}

struct SolarView: View {
	
	// MARK: - PROPS

	@Environment(\.calendar) var calendar
	@Environment(\.temporalSpec) var temporalSpec
	
	@State private var temporalConfig = TemporalConfig(currentTime: Date())
	let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

	@State private var scrollOffset: CGFloat = .zero

	// MARK: - BODY
	var body: some View {
		ScrollViewReader { scrollProxy in
			ZStack {
				Color.pink.opacity(0.2).ignoresSafeArea()
				
				ScrollViewOffset {
					scrollOffset = $0
				} content: {
					ZStack(alignment: .top) {
						Color.clear
							.onAppear {
								scrollToNow(proxy: scrollProxy)
							}
							.onReceive(timer) { _ in
								self.temporalConfig = TemporalConfig(currentTime: Date())
							}
							.onChange(of: cursorTimeHour) { [cursorTimeHour] newValue in

								let impact = UIImpactFeedbackGenerator(style: .soft)
								let generator = UISelectionFeedbackGenerator()

								if newValue != cursorTimeHour {
									
									let newHour = calendar.component(.hour, from: newValue)
									let oldHour = calendar.component(.hour, from: cursorTimeHour)
									// show the major tick every 4 hours
									let isNewMajor = Double(newHour).truncatingRemainder(dividingBy: 4) == 0
									let isOldMajor = Double(oldHour).truncatingRemainder(dividingBy: 4) == 0
									
									// compare oldHour to newHour because the direction affects the Major
									if (oldHour < newHour && isNewMajor) || (oldHour > newHour && isOldMajor) {
										impact.impactOccurred()
									}
									else {
										generator.selectionChanged()
									}
								}
							}

						SunsetView(temporalConfig: temporalConfig)
						
						TickMarks(temporalConfig: temporalConfig)
						
						VStack(spacing: 0) {
							Rectangle()
								.fill(Color.clear)
								.frame(height: currentTimeOffset)
							Rectangle()
								.fill(Color.red)
								.frame(maxWidth: .infinity, maxHeight: 2)
								.id("now")
						}//: VStack - "now" line

						ZStack {
							Circle()
								.fill(Color.gray.opacity(0.85))
								.frame(width: 150, height: 150)
								.shadow(radius: 8)
								.overlay(
									VStack {
										Text(formatTime(currentTime))
										Text("\(scrollOffset, specifier: "%.1f")")
										Text(formatTime(cursorTime))
										Text(formatTime(cursorTimeHour))
									}
								)
								.onTapGesture {
									scrollToNow(proxy: scrollProxy)
								}
							
							Rectangle()
								.fill(Color.blue)
								.frame(maxWidth: .infinity, maxHeight: 2)
						}//: ZStack - sun circle
						.frame(height: temporalSpec.contentSize)
						// will stay fixed because inverse of offset
						.offset(x: 0, y: -scrollOffset)

					}//: ZStack
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
				}//: ScrollViewOffset
			}//: ZStack
			.background(Color.blue.opacity(0.2))
		}//: ScrollViewReader
	}//: body

	// MARK: - COMPUTES
	
	var currentTime: Date {
		Date().round(precision: minutes(5))
	}
	var currentTimeOffset: CGFloat {
		let numberOfMinutes = Calendar.current.dateComponents(
			[.minute],
			from: temporalConfig.startTime,
			to: currentTime
		).minute ?? 0
		
		return CGFloat(numberOfMinutes) * temporalSpec._minuteSize
	}
	
	var cursorTime: Date {
		let cursorOffset = temporalSpec.contentSize / 2
		let minutesToAdd = (cursorOffset + scrollOffset * -1) / temporalSpec._minuteSize
		
		return temporalConfig.startTime
			.advanced(by: minutes(Double(minutesToAdd)))
			.round(precision: minutes(5))
	}
	var cursorTimeHour: Date {
		cursorTime.floor(precision: hours(1))
	}
	
	// MARK: - METHODS
	
	func scrollToNow(proxy: ScrollViewProxy) {
		withAnimation {
			proxy.scrollTo("now", anchor: .center)
		}
	}
}

struct SunsetView: View {

	// MARK: - PROPS
	
	@Environment(\.temporalSpec) var temporalSpec
	var temporalConfig: TemporalConfig

	let Sun = SunCalc()
	var lat = 39.856672
	var lng = -86.132480

	// MARK: - BODY
	
	var body: some View {
		let offset = getOffsetForTime(fromDate: temporalConfig.startTime, toTime: solarBlocks[0].interval.start, minuteHeight: temporalSpec._minuteSize)
		
		ZStack(alignment: .top) {
			VStack(spacing: 0) {
				ForEach(solarBlocks.indices) { index in
					let block = solarBlocks[index]
					let offset = getOffsetForTime(fromDate: temporalConfig.startTime, toTime: block.interval.start, minuteHeight: temporalSpec._minuteSize)
					let height = CGFloat(block.interval.duration) / 60 * temporalSpec._minuteSize
					let time = DateFormatter.shortFormatter.string(from: block.interval.start)

					Rectangle()
						.fill(getSolarColor(block.name).getSecondaryColor())
						.frame(height: height)
						.overlay(
							VStack {
								HStack {
									Text("\(getSolarLabel(block.name)) \(index)")
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
				}
			}//: VStack - Blocks
			.offset(x: 0, y: offset)

			ForEach(solarPoints.indices) { index in
				let moment = solarPoints[index]
				let offset = getOffsetForTime(fromDate: temporalConfig.startTime, toTime: moment.time, minuteHeight: temporalSpec._minuteSize)
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
			}//: ForEach - Points
		}//: ZStack
		.frame(height: temporalSpec.contentSize * 3, alignment: .top)
	}

	// MARK: - COMPUTES
	
	let dayRange = [
		-1, 0, 1, 2, 3
	]

	typealias SolarMoment = (time: Date, name: String)

	var solarTimes: [SolarMoment] {
		var allSolarTimes: [(time: Date, name: String)] = []
		
		for day in dayRange {
			let dateValue = Calendar.current.date(
				byAdding: .day, value: day, to: temporalConfig.currentDay
			)!
			let times = Sun.getTimes(date: dateValue, lat: lat, lng: lng)
			for (name, time) in times {
				allSolarTimes.append((time, name))
			}
		}
		
		allSolarTimes.sort { $0.time < $1.time }
		
		return allSolarTimes
	}
	
	let pointNames = [
		"nadir", "solarNoon"
	]
	
	var solarPoints: [SolarMoment] {
		solarTimes.filter { pointNames.contains($0.name) }
	}
	
	let blockNames = [
		"night", "nightEnd",
		"goldenHourEnd", "goldenHour"
	]
	
	typealias SolarInterval = (interval: DateInterval, name: String)

	var solarBlocks: [SolarInterval] {
		var intervals: [SolarInterval] = []
		
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

}

// MARK: - HELPER FUNCTIONS

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

func formatTime(_ date: Date) -> String {
	DateFormatter.bestTimeFormatter.string(from: date)
}

// MARK: - MODEL

struct TemporalConfig {
	@Environment(\.calendar) var calendar
	
	var currentTime: Date
	
	// start of the day
	var currentDay: Date {
		calendar.startOfDay(for: currentTime)
	}
	var firstDay: Date {
		calendar.date(
			byAdding: .day, value: -1, to: currentDay
		)!
	}
	
	// rounded to hour
	var currentHour: Date {
		currentTime.floor(precision: minutes(60))
	}
	
	var rangeUnit: Calendar.Component = .hour
	var rangeValue: Int = 36
	
	
	var startTime: Date {
		calendar.date(
			byAdding: rangeUnit, value: -(rangeValue), to: currentHour
		)!
	}
	
	// currentHour - rangeInHours → rounded to hour
	var startHour: Date {
		calendar.date(
			byAdding: rangeUnit, value: -(rangeValue + 1), to: currentHour
		)!
	}
	// currentHour + rangeInHours → rounded to hour
	var endHour: Date {
		calendar.date(
			byAdding: rangeUnit, value: rangeValue + 1, to: currentHour
		)!
	}
	
	var hours: [Date] {
		calendar.generate(
			inside: DateInterval(start: startHour, end: endHour),
			matching: DateComponents(minute: 0, second: 0)
		)
	}
	
	init(currentTime: Date) {
		self.currentTime = currentTime
	}
}
