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
- [x] figure out scroll throttling
FUCK IT WAS ANIMATION

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
				
				SunsetWrapperView(
					temporalConfig: temporalConfig,
					cursorTime: cursor
				)
				
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
							.opacity(0.1)
						
						// SolarFocalPointView(temporalConfig: temporalConfig)
						// 	.opacity(0.5)
						
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
		getOffsetForTime(
			from: temporalConfig.startTime,
			to: currentTime,
			minuteSize: temporalSpec._minuteSize
		)
	}
	
	var cursor: Date {
		let cursorOffset = temporalSpec.contentSize / 2
		let offset = (cursorOffset + scrollOffset * -1)
		
		return getTimeFromOffset(
			from: temporalConfig.startTime,
			offset: offset,
			minuteSize: temporalSpec._minuteSize
		)
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
			let offset = getOffsetForTime(
				from: temporalConfig.startTime,
				to: start,
				minuteSize: temporalSpec._minuteSize
			)
			
			ZStack(alignment: .top) {
				VStack(spacing: 0) {
					ForEach(solarModel.focalBlocks.indices) { index in
						let block = solarModel.focalBlocks[index]
						// let offset = getOffsetForTime(from: temporalConfig.startTime, to: block.interval.start, minuteSize: temporalSpec._minuteSize)
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
				let offset = getOffsetForTime(
					from: temporalConfig.startTime,
					to: moment.time,
					minuteSize: temporalSpec._minuteSize
				)
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
		ZStack(alignment: .top) {
			if let solarPhaseProgress = solarModel.getPhaseProgressFor(time: cursorTime) {
				SunsetView(solarPhaseProgress: solarPhaseProgress)
			}
		}//: ZStack
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
}

struct SunsetView: View {

	var solarPhaseProgress: SolarPhaseProgress
	
	var gradients: [[NativeStop]] {
		[
			night, // 0
			twilight, // 1
			sun, // 2
			shine, // 3
			day // 4
		]
	}
	
	var body: some View {
		ZStack(alignment: .top) {
			
			switch solarPhaseProgress {
				case SolarPhaseProgress.night(let progress):
					Group {
						Rectangle()
							.modifier(
								AnimatableGradient(
									all: gradients,
									fromIndex: 1,
									toIndex: 0,
									pct: CGFloat(progress)
								)
							)
						Text("night \(progress, specifier: "%.2f")")
							.font(.largeTitle)
							.padding(.top, 164)
					}
				
				case SolarPhaseProgress.dawn(let progress):
					Group {
						Rectangle()
							.modifier(
								AnimatableGradient(
									all: gradients,
									fromIndex: 1,
									toIndex: 2,
									pct: CGFloat(progress)
								)
							)
						Text("dawn \(progress, specifier: "%.2f")")
							.font(.largeTitle)
							.padding(.top, 164)
					}
				case SolarPhaseProgress.rise(let progress):
					Group {
						Rectangle()
							.modifier(
								AnimatableGradient(
									all: gradients,
									fromIndex: 2,
									toIndex: 2,
									pct: CGFloat(progress)
								)
							)
						Text("sunrise \(progress, specifier: "%.2f")")
							.font(.largeTitle)
							.padding(.top, 164)
					}
				case SolarPhaseProgress.shine(let progress):
					Group {
						Rectangle()
							.modifier(
								AnimatableGradient(
									all: gradients,
									fromIndex: 2,
									toIndex: 3,
									pct: CGFloat(progress)
								)
							)
						Text("golden hour \(progress, specifier: "%.2f")")
							.font(.largeTitle)
							.padding(.top, 164)
					}
				case SolarPhaseProgress.day(let progress):
					Group {
						Rectangle()
							.modifier(
								AnimatableGradient(
									all: gradients,
									fromIndex: 4,
									toIndex: 3,
									pct: CGFloat(1 - progress)
								)
							)
						Text("day \(progress, specifier: "%.2f")")
							.font(.largeTitle)
							.padding(.top, 164)
					}
				case SolarPhaseProgress.set(let progress):
					Group {
						Rectangle()
							.modifier(
								AnimatableGradient(
									all: gradients,
									fromIndex: 2,
									toIndex: 2,
									pct: CGFloat(progress)
								)
							)
						Text("sunset \(progress, specifier: "%.2f")")
							.font(.largeTitle)
							.padding(.top, 164)
					}
				case SolarPhaseProgress.dusk(let progress):
					Group {
						Rectangle()
							.modifier(
								AnimatableGradient(
									all: gradients,
									fromIndex: 2,
									toIndex: 1,
									pct: CGFloat(progress)
								)
							)
						Text("dusk \(progress, specifier: "%.2f")")
							.font(.largeTitle)
							.padding(.top, 164)
					}
			}
		}//: ZStack
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
	
	let night: [NativeStop] = [
		(color: NativeColor(Color(#colorLiteral(red: 0.003380405018, green: 0.01248565037, blue: 0.1030821726, alpha: 1))), location: 0.0),
		(color: NativeColor(Color(#colorLiteral(red: 0.003690367797, green: 0.02489320002, blue: 0.1723413169, alpha: 1))), location: 0.33),
		(color: NativeColor(Color(#colorLiteral(red: 0.01167470682, green: 0.04773455113, blue: 0.3371214271, alpha: 1))), location: 0.66),
		(color: NativeColor(Color(#colorLiteral(red: 0.0904847458, green: 0.002781496383, blue: 0.4793588519, alpha: 1))), location: 1.0),
	]
	
	let twilight: [NativeStop] = [
		(color: NativeColor(Color(#colorLiteral(red: 0.0009479976725, green: 0.02773871832, blue: 0.2280530632, alpha: 1))), location: 0.0),
		(color: NativeColor(Color(#colorLiteral(red: 0.003361887531, green: 0.16669783, blue: 0.479382813, alpha: 1))), location: 0.33),
		(color: NativeColor(Color(#colorLiteral(red: 0.1716162264, green: 0.1648572981, blue: 0.7561655641, alpha: 1))), location: 0.66),
		(color: NativeColor(Color(#colorLiteral(red: 0.5243727565, green: 0.1154649928, blue: 0.7274202704, alpha: 1))), location: 1.0),
	]
	
	let sun: [NativeStop] = [
		(color: NativeColor(Color(#colorLiteral(red: 0.1687308848, green: 0.09176445752, blue: 0.3746856749, alpha: 1))), location: 0.0),
		(color: NativeColor(Color(#colorLiteral(red: 0.5273597836, green: 0.04536166787, blue: 0.1914333701, alpha: 1))), location: 0.33),
		(color: NativeColor(Color(#colorLiteral(red: 0.9155419469, green: 0.4921894073, blue: 0.1403514445, alpha: 1))), location: 0.66),
		(color: NativeColor(Color(#colorLiteral(red: 0.9246239066, green: 0.8353297114, blue: 0.01127522066, alpha: 1))), location: 1.0),
	]
	
	let shine: [NativeStop] = [
		(color: NativeColor(Color(#colorLiteral(red: 0.0158313401, green: 0.005890237633, blue: 0.6395550966, alpha: 1))), location: 0.0),
		(color: NativeColor(Color(#colorLiteral(red: 0.00617591897, green: 0.3323536515, blue: 0.6396250129, alpha: 1))), location: 0.33),
		(color: NativeColor(Color(#colorLiteral(red: 0.9244585633, green: 0.9151363969, blue: 0.5425032377, alpha: 1))), location: 0.66),
		(color: NativeColor(Color(#colorLiteral(red: 0.9897723794, green: 0.8248019814, blue: 0.1941889524, alpha: 1))), location: 1.0),
	]
	
	let day: [NativeStop] = [
		(color: NativeColor(Color(#colorLiteral(red: 0.009109710343, green: 0.2355630994, blue: 0.7201706767, alpha: 1))), location: 0.0),
		(color: NativeColor(Color(#colorLiteral(red: 0.1112611368, green: 0.4668209553, blue: 0.8761388063, alpha: 1))), location: 0.33),
		(color: NativeColor(Color(#colorLiteral(red: 0.5453876257, green: 0.7670046687, blue: 0.958891809, alpha: 1))), location: 0.66),
		(color: NativeColor(Color(#colorLiteral(red: 0.9247719646, green: 0.9830601811, blue: 0.9897001386, alpha: 1))), location: 1.0),
	]
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

func getOffsetForTime(from: Date, to: Date, minuteSize: CGFloat) -> CGFloat {
	let numberOfMinutes = from.distance(to: to) / 60
	
	return CGFloat(numberOfMinutes) * minuteSize
}

func getTimeFromOffset(from: Date, offset: CGFloat, minuteSize: CGFloat) -> Date {
	let minutesToAdd = offset / minuteSize
	
	return from
		.advanced(by: minutes(Double(minutesToAdd)))
}

func formatTime(_ date: Date) -> String {
	DateFormatter.bestTimeFormatter.string(from: date)
}
