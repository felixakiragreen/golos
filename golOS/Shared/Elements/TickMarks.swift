//
//  TickMarks.swift
//  golOS
//
//  Created by Felix Akira Green on 2/15/21.
//

import SwiftUI

// MARK: - PREVIEW
struct TickMarks_Previews: PreviewProvider {
	static var previews: some View {
		TickMarks(temporalConfig: TemporalConfig(currentTime: Date()))
	}
}

struct TickMarks: View {
	// MARK: - PROPS

	@Environment(\.calendar) var calendar
	@Environment(\.temporalSpec) var temporalSpec

	var temporalConfig: TemporalConfig

	// MARK: - BODY

	var body: some View {
		LazyVStack(spacing: 0) {
			ForEach(temporalConfig.hours.indices) { hourIndex in
				let time = temporalConfig.hours[hourIndex]
				let hour = calendar.component(.hour, from: time)
				// show the major tick every 4 hours
				let isMajor = Double(hour).truncatingRemainder(dividingBy: 4) == 0

				Group {
					if isMajor {
						MajorTick()
					}
					else {
						MinorTick()
					}
				}
				// .overlay(
				// 	Text("\(DateFormatter.shortFormatter.string(from: time))")
				// )
				.frame(height: temporalSpec._minuteSize * 60)
			}
		}
	}
}

struct MajorTick: View {
	var width: CGFloat = 12
	var height: CGFloat = 2

	var body: some View {
		Tick(
			size: CGSize(width: width, height: height),
			color: ColorPreset(lum: .semiDark).getColor()
		)
	}
}

struct MinorTick: View {
	var width: CGFloat = 6
	var height: CGFloat = 2

	var body: some View {
		Tick(
			size: CGSize(width: width, height: height),
			color: ColorPreset(lum: .normal).getColor()
		)
	}
}

struct Tick: View {
	var size: CGSize
	var color: Color

	var body: some View {
		VStack {
			HStack {
				Capsule()
					.frame(width: size.width, height: size.height)
					.offset(x: -size.height, y: -size.height / 2)
				Spacer()
				Capsule()
					.frame(width: size.width, height: size.height)
					.offset(x: size.height, y: -size.height / 2)
			}
			.foregroundColor(color)
			Spacer()
		}
	}
}
