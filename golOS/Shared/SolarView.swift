//
//  SolarView.swift
//  golOS
//
//  Created by Felix Akira Green on 2/14/21.
//

import SwiftUI

// MARK: - PREVIEW
struct SolarView_Previews: PreviewProvider {
	
	static var height: CGFloat = (UIScreen.main.bounds.height - 66)
	
	static var previews: some View {
		SolarView(height: height)
	}
}

// let screenWidth = UIScreen.main.bounds.width


struct SolarView: View {
	// MARK: - PROPS

	@GestureState private var translation: CGSize = .zero
	
	@State private var offset: CGSize = .zero
	
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
	
	// MARK: - BODY
	var body: some View {
		ZStack {
			Color.red.ignoresSafeArea()
				.onAppear {
					scrollToNow()
				}

			SunsetView(height: height)
				.frame(height: height)
				.offset(x: 0, y: _scrollOffset)
			
			VStack {
				Circle()
					.fill(Color.gray.opacity(0.5))
					.frame(width: 200, height: 200)
					.shadow(radius: 8)
					.overlay(
						VStack {
							Text(currentTimeString)
							Text("\(_scrollOffset, specifier: "%.2f")")
							Text(cursorTimeString)
							Text("\(_minuteHeight, specifier: "%.2f")")
						}
					)
					.onTapGesture {
						scrollToNow()
					}
			}
			
			Rectangle()
				.fill(Color.blue)
				.frame(maxWidth: .infinity, maxHeight: 2)
			
			ZStack {
				Rectangle()
					.fill(Color.red)
					.frame(maxWidth: .infinity, maxHeight: 2)
					.offset(x: 0, y: _scrollOffset + currentTimeOffset)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
			
		}
		.gesture(drag)
	}

	var drag: some Gesture {
		DragGesture()
			.updating($translation) { value, state, _ in
				state = value.translation
			}
			.onEnded { value in
				offset += value.translation
				withAnimation(.spring()) {
					offset += value.predictedEndTranslation - value.translation
					// offset.height = clamp(value: offset.height, lower: -height, upper: height)
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
			from: today,
			to: currentTime
		).minute ?? 0
		
		return CGFloat(numberOfMinutes) * _minuteHeight
	}
	
	var cursorTime: Date {
		let cursorOffset = height / 2
		
		let minutesToAdd = (cursorOffset + _scrollOffset * -1) / _minuteHeight
		
		return today
			.advanced(by: minutes(Double(minutesToAdd)))
			.round(precision: minutes(5))
	}
	
	var cursorTimeString: String {
		DateFormatter.bestTimeFormatter.string(from: cursorTime)
	}
	
	// scroll to goToNow()
	func scrollToNow() {
		let cursorOffset = height / 2
		// maxWidth: .infinity, maxHeight: .infinity,
		
		let scrollTo = (cursorOffset + _scrollOffset * -1) - currentTimeOffset
		
		withAnimation {
			self.offset += CGSize(width: 0, height: scrollTo)
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
		-1, 0, 1, 2
	]
	var ystrDate: Date {
		Calendar.current.date(
			byAdding: .day, value: -1, to: date
		)!
	}
	var tmrwDate: Date {
		Calendar.current.date(
			byAdding: .day, value: 1, to: date
		)!
	}
	var omrwDate: Date {
		Calendar.current.date(
			byAdding: .day, value: 2, to: date
		)!
	}

	let Sun = SunCalc()
	
	var lat = 39.856672
	var lng = -86.132480

	let acceptedNames = [
		"night", //"nadir", "nightEnd",
		"goldenHourEnd"//, "solarNoon", "goldenHour"
	]

	var solarTimes: [(time: Date, name: String)] {
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
		
		return allSolarTimes.filter { acceptedNames.contains($0.name) }
	}
	
	var body: some View {
		// let offset = (self.translation.height + self.offset.height)
		
		// .truncatingRemainder(dividingBy: screenHeight)
		
		ZStack(alignment: .top) {
			LazyVStack(spacing: 0) {
				DayCycle(label: "yday")
					.frame(height: height)
				DayCycle(label: "today")
					.frame(height: height)
				DayCycle(label: "tmrw")
					.frame(height: height)
			}
			ForEach(solarTimes.indices) { index in
				let interval = solarTimes[index]
				let offset = getOffsetForTime(fromDate: ystrDate, toTime: interval.time, minuteHeight: _minuteHeight)
				let time = DateFormatter.shortFormatter.string(from: interval.time)
					
				Rectangle()
					.fill(getSolarColor(name: interval.name))
					.frame(maxWidth: .infinity, maxHeight: 24)
					.overlay(Text("\(interval.name) \(offset, specifier: "%.1f") \(time)"))
					.offset(x: 0, y: offset)
					
			}
			Text("asdf: \(solarTimes.count)")
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		.onAppear {
			print(solarTimes)
		}
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


func getSolarColor(name: String) -> Color {
	switch name {
		case "night", "nadir", "nightEnd":
			return ColorPreset(hue: .purple, lum: .normal).getColor()
		case "goldenHourEnd", "solarNoon", "goldenHour":
			return ColorPreset(hue: .yellow, lum: .normal).getColor()
		default:
			return Color("green.100")
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
