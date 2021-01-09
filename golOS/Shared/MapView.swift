//
//  SolarView.swift
//  golOS (iOS)
//
//  Created by Felix Akira Green on 1/5/21.
//

import SwiftUI

// MARK: - PREVIEW

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView()
			.preferredColorScheme(.dark)
	}
}

struct MapView: View {
	@Environment(\.calendar) var calendar

	var body: some View {
		let yday = calendar.date(
			byAdding: .hour, value: -12, to: Date()
		)!
		let tmrw = calendar.date(
			byAdding: .hour, value: 12, to: Date()
		)!
		let hours: [Date] = calendar.generate(
			inside: DateInterval.init(start: yday, end: tmrw),
			matching: DateComponents(minute: 0, second: 0)
		)

		VStack(spacing: 1) {
		
			ForEach(hours, id: \.self) { h in
				let time = DateFormatter.hourFormatter.string(from: h)
				HStack {
					Text(time)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(
					Hexagon()
						.foregroundColor(Color("grey.sys.400"))
				)
			}
		}
	}
}
