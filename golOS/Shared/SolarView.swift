//
//  SolarView.swift
//  golOS (iOS)
//
//  Created by Felix Akira Green on 1/5/21.
//

import SwiftUI

// MARK: - PREVIEW

struct SolarView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			SolarView()
		}
		.preferredColorScheme(.dark)
	}
}

struct SolarView: View {
	@Environment(\.calendar) var calendar

	let Sun = SunCalc()

	var lat = 39.856672
	var lng = -86.132480

	var body: some View {
//		let yday = calendar.date(
//			byAdding: .hour, value: -12, to: Date()
//		)!
//		let tmrw = calendar.date(
//			byAdding: .hour, value: 12, to: Date()
//		)!
		let yday = calendar.date(
			byAdding: .day, value: -1, to: Date()
		)!
		let tmrw = calendar.date(
			byAdding: .day, value: 1, to: Date()
		)!
		let hours: [Date] = calendar.generate(
			inside: DateInterval(
				start: calendar.date(byAdding: .hour, value: -12, to: Date())!,
				end: calendar.date(byAdding: .hour, value: 12, to: Date())!
			),
			matching: DateComponents(minute: 0, second: 0)
		)

		let solarYday = Sun.getTimes(date: yday, lat: lat, lng: lng)
		let solarTday = Sun.getTimes(date: Date(), lat: lat, lng: lng)
		let solarTmrw = Sun.getTimes(date: tmrw, lat: lat, lng: lng)

		//	func hourString(from date: Date) -> String {
		//		return hourFormatter.string(from: date)
		//	}
		
		var allSolarTimes: [(time: Date, name: String)] = []
		
		for (name, time) in solarYday {
			allSolarTimes.append((time, name))
		}
		for (name, time) in solarTday {
			allSolarTimes.append((time, name))
		}
		for (name, time) in solarTmrw {
			allSolarTimes.append((time, name))
		}
		
		allSolarTimes.sort { $0.time < $1.time }
		
		var allSolarIntervals: [(interval: DateInterval, startName: String, endName: String)] = []
		
		for index in allSolarTimes.indices {
			if index + 2 < allSolarTimes.count {
				let thisTime = allSolarTimes[index]
				let nextTime = allSolarTimes[index + 1]
				
				let interval = (
					interval: DateInterval(start: thisTime.time, end: nextTime.time),
					startName: thisTime.name,
					endName: nextTime.name
				)
				
				allSolarIntervals.append(interval)
			}
		}
			
//			allSolarTimes.reduce([], { accm, nextValue in
//			let
//			return (
//
//				(interval: DateInterval(start: this.time, end: next.time), name: "\(this.name) \(next.name)")
//			)
//		})
		
//		let solarTimes = allSolarTimes.filter { abs(calendar.numberOfHoursBetween(Date(), and: $0.time)) <= 12 }
		
		let solarIntervals = allSolarIntervals.filter { abs(calendar.numberOfHoursBetween(Date(), and: $0.interval.start)) <= 12 || abs(calendar.numberOfHoursBetween(Date(), and: $0.interval.end)) <= 12 }
		
//		let solarTimes = solar.map()

		//	Text("\(previewTime, formatter: Self.timeFormatter)")

		/**
		
		TODO: FIX:
		
		the offsets aren't right because the solar is absolute to now...
		
		to fix I really need to do longer one... and put in a scrollview
		
		 */
		
		return ZStack {
			GeometryReader { geometry in
				let height = geometry.size.height
				let width = (geometry.size.width - 100) / 2
				let hourH: CGFloat = round(height / 24)
				
				HStack {
					Spacer()
					ZStack(alignment: .top) {
						ForEach(solarIntervals, id: \.interval) { interval, startName, _ in
							let startSeconds = CGFloat(Date().timeIntervalSince(interval.start))
//							let endSeconds = CGFloat(Date().timeIntervalSince(interval.end))
							let heightInSeconds = CGFloat(interval.duration)
//							let start = calendar.numberOfHoursBetween(Date(), and: interval.start)
							let offsetY = hourH * (startSeconds / 60 / 60) * -1

							let startTime = DateFormatter.timeFormatter.string(from: interval.start)

							HStack(alignment: .top) {
								Text(startTime)
									.font(.caption)
									.foregroundColor(getSolarTextColor(name: startName))
								Spacer()
								Text(startName)
									.foregroundColor(getSolarTextColor(name: startName))
									.font(.caption)
							}
						
							.frame(height: hourH * (heightInSeconds / 60 / 60), alignment: .top)
							.background(
								Rectangle()
//								.strokeBorder(lineWidth: 5)
									.foregroundColor(getSolarBackgroundColor(name: startName))
							)
				
							.offset(x: 0, y: offsetY + hourH * 12)
						
//							.offset
						}
					}.frame(maxWidth: width, maxHeight: .infinity, alignment: .top)
				}
				
				VStack(spacing: 0) {
					ForEach(hours, id: \.self) { h in
						//				let dateString = DateFormatter.hourFormatter.string(from: h)
						let s = DateFormatter.hourFormatter.string(from: h)
						HStack {
//							VStack { Divider() }
							Text(s)
								.foregroundColor(.secondary)
//							Divider().foregroundColor(.primary) }
							//					Text("\(h, formatter: DateFormatter.mediumTimeFormatter)")
						}
						.frame(maxWidth: .infinity, maxHeight: hourH)
						.overlay(
							Rectangle()
								.frame(maxWidth: .infinity, maxHeight: 1)
								.foregroundColor(.secondary),
							alignment: .top
						)
//						.background(
//							Hexagon()
//								.foregroundColor(Color("grey.sys.400"))
//						)
					}
				} //: VStack
				.onAppear {
					print(geometry.size.height)
					print(hourH)
//					print(solarTimes)
//					print(solarIntervals)
				}
			}
		}
	}
}

// TODO: move to somewhere better
func getSolarBackgroundColor(name: String) -> Color {
	switch name {
	case "night", "nadir", "nightEnd":
		return ColorPreset(hue: .blue, lum: .dark, sys: false).getColor()
	case "nauticalDawn":
		return ColorPreset(hue: .purple, lum: .semiDark, sys: false).getColor()
	case "dawn":
		return ColorPreset(hue: .red, lum: .medium, sys: false).getColor()
	case "sunrise", "sunriseEnd":
		return ColorPreset(hue: .orange, lum: .normal, sys: false).getColor()
	case "goldenHourEnd", "solarNoon":
		return ColorPreset(hue: .yellow, lum: .normal, sys: false).getColor()
	case "goldenHour", "sunsetStart", "sunset":
		return ColorPreset(hue: .orange, lum: .normal, sys: false).getColor()
	case "dusk":
		return ColorPreset(hue: .red, lum: .medium, sys: false).getColor()
	case "nauticalDusk":
		return ColorPreset(hue: .purple, lum: .semiDark, sys: false).getColor()
	default:
		return Color("green.900")
	}
}

// TODO: move to somewhere better
func getSolarTextColor(name: String) -> Color {
	switch name {
	case "night", "nadir", "nightEnd":
		return ColorPreset(hue: .blue, lum: .extraLight, sys: false).getColor()
	case "nauticalDawn":
		return ColorPreset(hue: .purple, lum: .extraLight, sys: false).getColor()
	case "dawn":
		return ColorPreset(hue: .red, lum: .extraDark, sys: false).getColor()
	case "sunrise", "sunriseEnd":
		return ColorPreset(hue: .orange, lum: .extraDark, sys: false).getColor()
	case "goldenHourEnd", "solarNoon":
		return ColorPreset(hue: .yellow, lum: .extraDark, sys: false).getColor()
	case "goldenHour", "sunsetStart", "sunset":
		return ColorPreset(hue: .orange, lum: .extraDark, sys: false).getColor()
	case "dusk":
		return ColorPreset(hue: .red, lum: .extraDark, sys: false).getColor()
	case "nauticalDusk":
		return ColorPreset(hue: .purple, lum: .extraLight, sys: false).getColor()
	default:
		return Color("green.100")
	}
}

extension Calendar {
	func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
		let fromDate = startOfDay(for: from) // <1>
		let toDate = startOfDay(for: to) // <2>
		let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
		  
		return numberOfDays.day!
	}
}

extension Calendar {
	func numberOfHoursBetween(_ from: Date, and to: Date) -> Int {
//		  let fromDate = startOfDay(for: from) // <1>
//		  let toDate = startOfDay(for: to) // <2>
		let numberOfHours = dateComponents([.hour], from: from, to: to) // <3>
		  
		return numberOfHours.hour!
	}
}
