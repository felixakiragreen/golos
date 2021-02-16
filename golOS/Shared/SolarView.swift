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


### 3 EFFECTS

- gradient shift of background

- [ ] TINY BUG - the haptic only happens AFTER the mark is passed, not on it

*/

// MARK: - PREVIEW
struct SolarView_Previews: PreviewProvider {

	static var previews: some View {
		GeometryReader { geometry in
			SolarView()
				.environment(\.temporalSpec, TemporalSpec(contentSize: geometry.size.height))
				.environmentObject(SolarModel())
		}
	}
}

struct SolarView: View {
	
	// MARK: - PROPS

	@Environment(\.calendar) var calendar
	@Environment(\.temporalSpec) var temporalSpec
	@EnvironmentObject var solarModel: SolarModel
	
	@State private var temporalConfig = TemporalConfig(currentTime: Date())
	let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

	@State private var scrollOffset: CGFloat = .zero

	// MARK: - BODY
	var body: some View {
		ScrollViewReader { scrollProxy in
			ZStack {
				Color.pink.opacity(0.2).ignoresSafeArea()
				
				SunsetWrapperView(temporalConfig: temporalConfig, cursorTime: cursorTime)
				
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
								scrollImpact(prevTime: cursorTimeHour, nextTime: newValue)
							}

						SolarBlockView(temporalConfig: temporalConfig)
							.opacity(0.2)
						
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
	
	func scrollImpact(prevTime: Date, nextTime: Date) {
		let impact = UIImpactFeedbackGenerator(style: .soft)
		let generator = UISelectionFeedbackGenerator()

		if nextTime != prevTime {
			
			let nextHour = calendar.component(.hour, from: nextTime)
			let prevHour = calendar.component(.hour, from: prevTime)

			// show the major tick every 4 hours
			let isNextMajor = Double(nextHour).truncatingRemainder(dividingBy: 4) == 0
			let isPrevMajor = Double(prevHour).truncatingRemainder(dividingBy: 4) == 0
			
			// compare prevHour to nextHour because the direction affects the Major
			if (prevHour < nextHour && isNextMajor) || (prevHour > nextHour && isPrevMajor) {
				impact.impactOccurred()
			}
			// handle the case of 0 & 23
			else if (prevHour == 23 && isNextMajor) || (nextHour == 23 && isPrevMajor) {
				impact.impactOccurred()
			}
			else {
				generator.selectionChanged()
			}
		}
	}
}

// MARK: - SUBVIEWS

struct SolarBlockView: View {

	// MARK: - PROPS
	
	@Environment(\.temporalSpec) var temporalSpec
	@EnvironmentObject var solarModel: SolarModel

	var temporalConfig: TemporalConfig

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
	let pointNames = [
		"nadir", "solarNoon",
		"sunrise", "sunsetStart",
	]
	
	// let blockNames = [
	// 	"night", "nightEnd",
	// 	"goldenHourEnd", "goldenHour"
	// ]
	
	let blockNames = [
		"night", "nightEnd",
		"nauticalDawn", "dawn",
		"sunriseEnd", "goldenHourEnd",
		"goldenHour", "sunset",
		"dusk", "nauticalDusk",
	]

	// "nadir", "solarNoon"
	
	// "night", "nightEnd",
	// "nauticalDawn", "dawn",
	// "sunrise", "sunriseEnd",
	// "goldenHourEnd", "goldenHour",
	// "sunsetStart", "sunset",
	// "dusk", "nauticalDusk",
	
	// case "night", "nadir", "nightEnd":
	// case "nauticalDawn":
	// case "dawn":
	// case "sunrise", "sunriseEnd":
	// case "goldenHourEnd", "solarNoon":
	// case "goldenHour", "sunsetStart", "sunset":
	// case "dusk":
	// case "nauticalDusk":
	
	var solarTimes: [SolarMoment] {
		solarModel.solarTimes
		// solarSpec.getTimesFor(date: temporalConfig.currentDay, range: dayRange)
	}
	
	var solarPoints: [SolarMoment] {
		solarTimes.filter { pointNames.contains($0.name) }
	}
	var solarBlocks: [SolarInterval] {
		solarModel.focalBlocks
		// solarSpec.getIntervalsFor(times: solarTimes, names: blockNames)
	}
}

struct SunsetWrapperView: View {
	
	// MARK: - PROPS
	
	@Environment(\.temporalSpec) var temporalSpec
	@EnvironmentObject var solarModel: SolarModel

	var temporalConfig: TemporalConfig
	var cursorTime: Date
	
	// MARK: - BODY
	
	var body: some View {
		// let offset = getOffsetForTime(fromDate: temporalConfig.startTime, toTime: solarBlocks[0].interval.start, minuteHeight: temporalSpec._minuteSize)
		
		ZStack(alignment: .top) {
			// Color.clear.opacity(0.2)
			SunsetView(solarBlock: insideBlock)
				.ignoresSafeArea()
		}//: ZStack
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
	
	// MARK: - COMPUTES

	var solarTimes: [SolarMoment] {
		solarModel.solarTimes
	}

	var solarBlocks: [SolarInterval] {
		solarModel.focalBlocks
	}
	
	var insideBlock: String {
		var acc = "FUCK"
		for block in solarBlocks {
			if block.interval.contains(cursorTime) {
				acc = getSolarLabel(block.name)
			}
		}
		return acc
	}

}

struct SunsetView: View {
	
	var solarBlock: String = "FUCK"
	
	var body: some View {
		ZStack(alignment: .top) {
			if solarBlock == "_day" {
				day
			} else if solarBlock == "_night" {
				night
			}
			else {
				dawn
			}
			
			Text("\(solarBlock)")
				.font(.largeTitle)
				.padding(.top, 164)
		}//: ZStack
		.animation(.default)
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
	
	var dawn: some View {
		LinearGradient(
			gradient: Gradient(stops: [
				Gradient.Stop(color: Color(#colorLiteral(red: 0.1687308848, green: 0.09176445752, blue: 0.3746856749, alpha: 1)), location: 0.0),
				Gradient.Stop(color: Color(#colorLiteral(red: 0.5273597836, green: 0.04536166787, blue: 0.1914333701, alpha: 1)), location: 0.33),
				Gradient.Stop(color: Color(#colorLiteral(red: 0.9155419469, green: 0.4921894073, blue: 0.1403514445, alpha: 1)), location: 0.66),
				Gradient.Stop(color: Color(#colorLiteral(red: 0.9246239066, green: 0.8353297114, blue: 0.01127522066, alpha: 1)), location: 1.0),
			]),
			startPoint: .top,
			endPoint: .bottom
		)
	}
	
	var day: some View {
		LinearGradient(
			gradient: Gradient(colors: [
				Color(#colorLiteral(red: 0.009109710343, green: 0.2355630994, blue: 0.7201706767, alpha: 1)),
				Color(#colorLiteral(red: 0.9282203913, green: 0.9830620885, blue: 0.989700973, alpha: 1)),
			]),
			startPoint: .top,
			endPoint: .bottom
		)
	}
	
	var night: some View {
		LinearGradient(
			gradient: Gradient(colors: [
				Color(#colorLiteral(red: 0.003380405018, green: 0.01248565037, blue: 0.1030821726, alpha: 1)),
				Color(#colorLiteral(red: 0.0904847458, green: 0.002781496383, blue: 0.4793588519, alpha: 1)),
			]),
			startPoint: .top,
			endPoint: .bottom
		)
	}
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
		case "nadir": return "NADIR"
		case "night": return "_night"

		case "nightEnd": return "astro.dawn"
		case "nauticalDawn": return "nauty.dawn"
		case "dawn": return "civie.dawn"
		case "sunrise": return "SUNRISE"
		case "sunriseEnd": return "goldy.dawn"
		
		case "goldenHourEnd": return "_day"
		case "solarNoon": return "NOON"
			
		case "goldenHour": return "goldy.dusk"
		case "sunsetStart": return "SUNSET"
		case "sunset": return "civie.dusk"
		case "dusk": return "nauty.dusk"
		case "nauticalDusk": return "astro.dusk"

		default: return name
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
