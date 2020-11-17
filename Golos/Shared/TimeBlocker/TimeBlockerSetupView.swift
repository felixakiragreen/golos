//
//  TimeBlockerSetupView.swift
//  Golos
//
//  Created by Felix Akira Green on 11/16/20.
//

import SwiftUI

struct TimeBlockerSetupView: View {
	var body: some View {
		VStack(alignment: .leading) {
			HStack(alignment: .firstTextBaseline) {
				Text("basic setup")
					.font(.title)
				Text("mm_time_blocker_v0·1")
					.foregroundColor(.secondary)
			}
			
			Divider()
			
			ChronotypeSetupView()
			
			Divider()
			
			Group {
				Text("Taxonomy")
					.font(.headline)
				Text("TODO: Do the tree structure...")
			}
		}
	}
}

struct TimeBlockerSetupView_Previews: PreviewProvider {
	static var previews: some View {
		TimeBlockerSetupView()
	}
}

struct Chronotype {
	typealias DateComponentsInterval = (DateComponents, DateComponents)
	
	var name: String
	var asleep: DateComponentsInterval
//	var wakeUp: DateInterval
//	var awake: DateInterval
//	var windDown: DateInterval
}

struct ChronotypeSetupView: View {
	let hours: [Int] = Array(stride(from: -12, to: 36, by: 6))
	
	let defaultChronotypes = [
		Chronotype(
			name: "Lion",
			asleep: (
				DateComponents(calendar: Calendar.current, hour: 1, minute: 0),
				DateComponents(calendar: Calendar.current, hour: 8, minute: 29)
			)
//			wakeUp: <#T##DateInterval#>,
//			awake: <#T##DateInterval#>,
//			windDown: <#T##DateInterval#>
		)
	]
	
	@State var selectedChronotype: Chronotype?
	
	init() {
		selectedChronotype = defaultChronotypes[0]
	}
	
	var body: some View {
		Group {
			Text("Chronotype")
				.font(.headline)
			VStack {
				HStack(spacing: 8.0) {
					ForEach(hours, id: \.self) { idx in
						HStack {
							Text("\(idx)")
							Spacer()
						}
					}.frame(maxWidth: .infinity)
				}
				ZStack {
					HStack(spacing: 4.0) {
						ForEach(0..<8) { _ in
							HStack {
								RoundedRectangle(cornerRadius: 8, style: .circular)
									.foregroundColor(Color.gray.opacity(0.2))
							}
						}
					}
					HStack(spacing: 4.0) {
						ForEach(0..<48) { _ in
							VStack {
								Capsule(style: .continuous)
									.foregroundColor(Color.gray.opacity(0.3))
									.padding(.vertical, 12.0)
							}
						}
					}
					HStack(spacing: 8.0) {
						ForEach(0..<24) { _ in
					
							VStack {
								Capsule()
									.foregroundColor(Color.blue)
					
							}.padding(.vertical, 24)
						}
					}
				}
			}
		}
	}
}
