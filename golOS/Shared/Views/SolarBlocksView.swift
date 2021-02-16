//
//  SolarBlocksView.swift
//  golOS
//
//  Created by Felix Akira Green on 2/16/21.
//

import SwiftUI

// MARK: - PREVIEW
struct SolarBlocksView_Previews: PreviewProvider {
	static var previews: some View {
		GeometryReader { geometry in
			SolarBlocksView(
				temporalConfig: TemporalConfig()
			)
			.environment(\.temporalSpec, TemporalSpec(contentSize: geometry.size.height))
			.environment(\.debugSpec, DebugSpec())
			.environmentObject(SolarModel())
		}
	}
}

struct SolarBlocksView: View {
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
				} //: VStack - Blocks
				.offset(x: 0, y: offset)
			} //: ZStack
			.frame(height: temporalSpec._scrollSize, alignment: .top)
		} //: if let
	} //: var body
}
