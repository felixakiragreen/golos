//
//  TimelineTrack.swift
//  golOS layout
//
//  Created by Felix Akira Green on 12/13/20.
//

import SwiftUI

struct TimelineTrack: View {
	// TODO: extract this logic into some higher level abstraction
	let zoomLevel: Double // 0.0 - 4.0
	let zoomUnits: [ZoomingUnits] // zoom configuration
	let interval: IntervalConfig

	var body: some View {
		let currentZoomIndex = min(Int(floor(zoomLevel)), zoomUnits.count - 1)
		let zoom = zoomUnits[currentZoomIndex]

		let totalMinutes = interval.count * interval.unit.rawValue
		let spacedSegments = Int(totalMinutes / zoom.space.rawValue) + 1

//		TODO: doesn't handle offset lul

		HStack(spacing: interval.spacing) {
			ForEach(0 ..< spacedSegments, id: \.self) { idx in

				let whichLine = renderWhichLine(zoom: zoom, index: idx, intervalUnit: zoom.space.rawValue)

				// line
				Group {
					if whichLine == .major {
						MajorLine()
					} else if whichLine == .mezzo {
						MezzoLine()
					} else if whichLine == .micro {
						MicroLine()
					} else if whichLine == .nano {
						NanoLine()
					}
				}.opacity(0.5)

				// space

//				if idx != spacedSegments.count {
				Rectangle()
					.frame(width: interval.radius * 3)
					.foregroundColor(Color.gray.opacity(0.1))
					.overlay(
						Text("\(idx)")
							.font(.caption)
					)
//				}
			}
		}
	}
}

// MARK: - PREVIEW
struct TimelineTrack_Previews: PreviewProvider {
	static var previews: some View {
		TimelineTrack(
			zoomLevel: 1.0,
			zoomUnits: [
				ZoomingUnits(
					space: .pentaminute,
					nano: .quarterhour,
					micro: .hour,
					mezzo: .hexahour,
					major: .day
				),
			],
			interval: IntervalConfig(
				unit: TimeUnit.hour,
				count: 24,
				radius: 1.0
			)
		)
	}
}

enum LineType {
	case none, nano, micro, mezzo, major
}

func renderWhichLine(
	zoom: ZoomingUnits,
	index: Int,
	intervalUnit: Int
) -> LineType {
	if let majorValue = zoom.major?.rawValue {
		let majorInterval = Int(majorValue / intervalUnit)
		if index % majorInterval == 0 {
			return .major
		}
	}
	if let mezzoValue = zoom.mezzo?.rawValue {
		let mezzoInterval = Int(mezzoValue / intervalUnit)
		if index % mezzoInterval == 0 {
			return .mezzo
		}
	}
	if let microValue = zoom.micro?.rawValue {
		let microInterval = Int(microValue / intervalUnit)
		if index % microInterval == 0 {
			return .micro
		}
	}
	if let nanoValue = zoom.nano?.rawValue {
		let nanoInterval = Int(nanoValue / intervalUnit)
		if index % nanoInterval == 0 {
			return .nano
		}
	}
	return .none
}

// MARK: - SUBVIEWS

struct MajorLine: View {
	var body: some View {
		Rectangle()
			.frame(width: 5.0)
			.foregroundColor(Color.green)
	}
}

struct MezzoLine: View {
	var body: some View {
		Rectangle()
			.frame(width: 3.0)
			.foregroundColor(Color.red)
	}
}

struct MicroLine: View {
	var body: some View {
		Rectangle()
			.frame(width: 1.0)
			.foregroundColor(Color.blue)
	}
}

struct NanoLine: View {
	var body: some View {
		Rectangle()
			.frame(width: 1.0)
			.foregroundColor(Color.purple)
	}
}
