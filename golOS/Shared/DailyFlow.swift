//
//  DailyFlow.swift
//  golOS
//
//  Created by Felix Akira Green on 1/3/21.
//

import SwiftUI

// MARK: - PREVIEW
struct DailyFlow_Previews: PreviewProvider {
	static var previews: some View {
		DailyFlow(dailyAnnotations: .constant(DailyAnnotation.testData), saveAction: {})
	}
}


struct DailyFlow: View {
	// MARK: - PROPS
	@Binding var dailyAnnotations: [DailyAnnotation]
	@Environment(\.scenePhase) private var scenePhase

	let saveAction: () -> Void

	// MARK: - BODY
	var body: some View {
		VStack {
			List {
				ForEach(dailyAnnotations) { day in
					// DO INDICES
					HStack {
						VStack {
							Text("\(day.id)")
								.font(.caption)
								.foregroundColor(.secondary)
							if let start = day.start {
								let dateString = DateFormatter.mediumDateTimeFormatter.string(from: start)
								Text("start → \(dateString)")
							}
							if let stop = day.stop {
								let dateString = DateFormatter.mediumDateTimeFormatter.string(from: stop)
								Text("stop → \(dateString)")
							} else {
								Button("end my day") {
									let endTime = Date().addingTimeInterval(minutes(60))
									
									if let dayIndex = self.dailyAnnotations.firstIndex(where: { $0.id == day.id }) {
										dailyAnnotations[dayIndex].stop = endTime
									} else {
										print("could not find index of this day with ID: \(day.id)")
		//								TODO: handle
		//								throw myError
									}
								}
							}
						}//: VStack
						Spacer()
//						Button() {
//
//						} label: {
//							Image(systemName: "trash")
//						}
						
					}//: HStack
					.padding(.vertical)
//					.background(Color("grey.sys.100"))
				}//: List
				.onDelete { indices in
					 dailyAnnotations.remove(atOffsets: indices)
				}
			}.listStyle(InsetGroupedListStyle())
			Button("start my day") {
				let newDay = DailyAnnotation(
					start: Date().addingTimeInterval(minutes(30))
				)
				
				dailyAnnotations.append(newDay)
			}
			.padding()
		}
		.onChange(of: scenePhase) { phase in
			if phase == .inactive { saveAction() }
		}
	}
}
