//
//  SolarFocalPointsView.swift
//  golOS
//
//  Created by Felix Akira Green on 2/16/21.
//

import SwiftUI

// MARK: - PREVIEW
struct SolarFocalPointsView_Previews: PreviewProvider {
	static var previews: some View {
		GeometryReader { geometry in
			SolarFocalPointsView(
				temporalConfig: TemporalConfig()
			)
			.environment(\.temporalSpec, TemporalSpec(contentSize: geometry.size.height))
			.environment(\.debugSpec, DebugSpec())
			.environmentObject(SolarModel())
		}
	}
}

struct SolarFocalPointsView: View {
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
			} //: ForEach - Points
		} //: ZStack
		.frame(height: temporalSpec._scrollSize, alignment: .top)
	}
}
