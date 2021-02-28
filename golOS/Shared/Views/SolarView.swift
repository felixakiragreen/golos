//
//  SolarView.swift
//  golOS
//
//  Created by Felix Akira Green on 2/14/21.
//

import SwiftUI

/*

Next steps:

- [ ] try adding the horizon
- [ ] TINY BUG - the haptic only happens AFTER the mark is passed, not on it

*/

// MARK: - PREVIEW
struct SolarView_Previews: PreviewProvider {

	static var previews: some View {
		GeometryReader { geometry in
			SolarView(
			)
			.environment(\.temporalSpec, TemporalSpec(contentSize: geometry.size.height))
			.environment(\.devDebug, true)
			.environmentObject(SolarModel())
		}
	}
}

struct SolarView: View {
	
	// MARK: - PROPS

	@Environment(\.calendar) var calendar
	@Environment(\.temporalSpec) var temporalSpec
	@Environment(\.devDebug) var devDebug
	@EnvironmentObject var solarModel: SolarModel
	
	@State private var temporalConfig = TemporalConfig(currentTime: Date())
	let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

	@State private var scrollOffset: CGFloat = .zero

	// MARK: - BODY
	var body: some View {
		ScrollViewReader { scrollProxy in
			ZStack {
				Color.pink.opacity(0.2).ignoresSafeArea()
				
				SolarSkyGradientView(
					temporalConfig: temporalConfig,
					cursorTime: cursor
				)
				.ignoresSafeArea()
				
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

						if devDebug {
							SolarBlocksView(temporalConfig: temporalConfig)
								.opacity(0.25)
						
							SolarFocalPointsView(temporalConfig: temporalConfig)
								.opacity(0.5)
						}
						
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
							VisualEffectBlur(
								blurStyle: .systemThinMaterial,
								vibrancyStyle: UIVibrancyEffectStyle.label
							) {
								VStack {
									Text(formatTime(currentTime))
									// Text("\(scrollOffset, specifier: "%.1f")")
									Text("e: \(formatTime(cursor))")
									Text("5: \(formatTime(cursorTime))")
									Text("h: \(formatTime(cursorTimeHour))")
								}
							}
							.frame(width: 150, height: 150)
							.clipShape(
								Circle()
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

// MARK: - HELPERS

func getOffsetForTime(from: Date, to: Date, minuteSize: CGFloat) -> CGFloat {
	let numberOfMinutes = from.distance(to: to) / 60
	
	return CGFloat(numberOfMinutes) * minuteSize
}

func getTimeFromOffset(from: Date, offset: CGFloat, minuteSize: CGFloat) -> Date {
	let minutesToAdd = offset / minuteSize
	
	return from
		.advanced(by: minutes(Double(minutesToAdd)))
}

fileprivate func formatTime(_ date: Date) -> String {
	DateFormatter.shortFormatter.string(from: date)
}

func debugTime(_ date: Date) -> String {
	DateFormatter.shortFormatter.string(from: date)
}
