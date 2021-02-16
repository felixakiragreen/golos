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
- [ ] figure out scroll throttling

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
						
						// SolarFocalPointView(temporalConfig: temporalConfig)
						
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
										// Text("\(scrollOffset, specifier: "%.1f")")
										Text("e: \(formatTime(cursor))")
										Text("5: \(formatTime(cursorTime))")
										Text("h: \(formatTime(cursorTimeHour))")
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
	
	var cursor: Date {
		let cursorOffset = temporalSpec.contentSize / 2
		let minutesToAdd = (cursorOffset + scrollOffset * -1) / temporalSpec._minuteSize
		
		return temporalConfig.startTime
			.advanced(by: minutes(Double(minutesToAdd)))
	}
	var cursorTime: Date {
		cursor.round(precision: minutes(5))
	}
	var cursorTimeHour: Date {
		cursor.floor(precision: hours(1))
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
		if let firstBlock = solarModel.focalBlocks.first {
			let start: Date = firstBlock.interval.start
			let offset = getOffsetForTime(fromDate: temporalConfig.startTime, toTime: start, minuteHeight: temporalSpec._minuteSize)
			
			ZStack(alignment: .top) {
				VStack(spacing: 0) {
					ForEach(solarModel.focalBlocks.indices) { index in
						let block = solarModel.focalBlocks[index]
						// let offset = getOffsetForTime(fromDate: temporalConfig.startTime, toTime: block.interval.start, minuteHeight: temporalSpec._minuteSize)
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
										// Text("\(offset, specifier: "%.1f")")
										// Spacer()
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
				
			}//: ZStack
			.frame(height: temporalSpec.contentSize * 3, alignment: .top)
		}//: if let
	}//: var body
}

struct SolarFocalPointView: View {
	
	// MARK: - PROPS
	
	@Environment(\.temporalSpec) var temporalSpec
	@EnvironmentObject var solarModel: SolarModel
	
	var temporalConfig: TemporalConfig
	
	// MARK: - BODY
	
	var body: some View {
		ZStack(alignment: .top) {
			ForEach(solarModel.focalPoints.indices) { index in
				let moment = solarModel.focalPoints[index]
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
			// SunsetView(solarBlock: insideBlock)
			
			if let solarPhaseProgress = solarModel.getPhaseProgressFor(time: cursorTime) {
				SunsetView(solarPhaseProgress: solarPhaseProgress)
			}
			// 	.ignoresSafeArea()
		}//: ZStack
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
}

struct SunsetView: View {
	
	var solarBlock: String = "FUCK"
	var solarPhaseProgress: SolarPhaseProgress
	
	var body: some View {
		ZStack(alignment: .top) {
			switch solarPhaseProgress {
				case SolarPhaseProgress.night(let progress):
					Group {
						night
						Text("night \(progress, specifier: "%.2f")")
							.font(.largeTitle)
							.padding(.top, 164)
					}
				case SolarPhaseProgress.day(let progress):
					Group {
						day
						Text("day \(progress, specifier: "%.2f")")
							.font(.largeTitle)
							.padding(.top, 164)
					}
				
				case SolarPhaseProgress.dawn(let progress):
					Group {
						dawn
						Text("dawn \(progress, specifier: "%.2f")")
							.font(.largeTitle)
							.padding(.top, 164)
					}
				case SolarPhaseProgress.rise(let progress):
					Group {
						dawn
						Text("sunrise \(progress, specifier: "%.2f")")
							.font(.largeTitle)
							.padding(.top, 164)
					}
				case SolarPhaseProgress.set(let progress):
					Group {
						dawn
						Text("sunset \(progress, specifier: "%.2f")")
							.font(.largeTitle)
							.padding(.top, 164)
					}
				case SolarPhaseProgress.dusk(let progress):
					Group {
						dawn
						Text("dusk \(progress, specifier: "%.2f")")
							.font(.largeTitle)
							.padding(.top, 164)
					}
				case SolarPhaseProgress.shine(let progress):
					Group {
						dawn
						Text("golden hour \(progress, specifier: "%.2f")")
							.font(.largeTitle)
							.padding(.top, 164)
					}
				default:
					dawn
			}
			// if solarPhaseProgress == SolarPhaseProgress.day {
			// 	day
			// } else if solarBlock == "_night" {
			// 	night
			// }
			// else {
			// 	dawn
			// }
			
			
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
