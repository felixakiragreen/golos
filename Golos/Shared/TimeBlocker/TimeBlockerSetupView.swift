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

struct ChronotypeRoutine: Identifiable, Hashable {
	var id = UUID()
	var title: String
	var notes: String?
	var steps: [ChronotypeStep]
}

struct ChronotypeStep: Identifiable, Hashable {
	var id = UUID()
	var title: String
	var color: Color
	var icon: String?
	var time: Date
}

//TODO: pull out data into model
//TODO: day visualization underneath the time inputs
//TODO: refactor the preset buttons into fun cardy/click buttons (emojis scale and take over)
//TODO: refactor the "input rows" into cards (like Apple's marketing cards)

struct ChronotypeSetupView: View {
	let defaultChronotypes: [ChronotypeRoutine] = [
		ChronotypeRoutine(title: "felix", steps: [
			ChronotypeStep(
				title: "asleep",
				color: .blue,
				icon: "moon.zzz",
				time: todayWith(hour: 1)
			),
			ChronotypeStep(
				title: "wakeUp",
				color: .green,
				icon: "sunrise",
				time: todayWith(hour: 8, minute: 30)
			),
			ChronotypeStep(
				title: "awake",
				color: .yellow,
				icon: "sun.max",
				time: todayWith(hour: 10, minute: 30)
			),
			ChronotypeStep(
				title: "windDown",
				color: .orange,
				icon: "sunset",
				time: todayWith(hour: 23)
			),
		]),
		ChronotypeRoutine(title: "🦁 lion", notes: "→ early", steps: [
			ChronotypeStep(
				title: "wakeUp",
				color: .green,
				icon: "sunrise",
				time: todayWith(hour: 6)
			),
			ChronotypeStep(
				title: "awake",
				color: .yellow,
				icon: "sun.max",
				time: todayWith(hour: 7)
			),
			ChronotypeStep(
				title: "windDown",
				color: .orange,
				icon: "sunset",
				time: todayWith(hour: 21)
			),
			ChronotypeStep(
				title: "asleep",
				color: .blue,
				icon: "moon.zzz",
				time: todayWith(hour: 22)
			),
		]),
		ChronotypeRoutine(title: "🐻 bear", notes: "→ inbetween", steps: [
			ChronotypeStep(
				title: "wakeUp",
				color: .green,
				icon: "sunrise",
				time: todayWith(hour: 7)
			),
			ChronotypeStep(
				title: "awake",
				color: .yellow,
				icon: "sun.max",
				time: todayWith(hour: 8)
			),
			ChronotypeStep(
				title: "windDown",
				color: .orange,
				icon: "sunset",
				time: todayWith(hour: 22)
			),
			ChronotypeStep(
				title: "asleep",
				color: .blue,
				icon: "moon.zzz",
				time: todayWith(hour: 23)
			),
		]),
		ChronotypeRoutine(title: "🐺 wolf", notes: "→ late", steps: [
			ChronotypeStep(
				title: "asleep",
				color: .blue,
				icon: "moon.zzz",
				time: todayWith(hour: 0)
			),
			ChronotypeStep(
				title: "wakeUp",
				color: .green,
				icon: "sunrise",
				time: todayWith(hour: 8)
			),
			ChronotypeStep(
				title: "awake",
				color: .yellow,
				icon: "sun.max",
				time: todayWith(hour: 9)
			),
			ChronotypeStep(
				title: "windDown",
				color: .orange,
				icon: "sunset",
				time: todayWith(hour: 23)
			),
			
		]),
		ChronotypeRoutine(title: "🐬 dolphin", notes: "→ insomnia", steps: [
			ChronotypeStep(
				title: "windDown",
				color: .orange,
				icon: "sunset",
				time: todayWith(hour: 0)
			),
			ChronotypeStep(
				title: "asleep",
				color: .blue,
				icon: "moon.zzz",
				time: todayWith(hour: 2)
			),
			ChronotypeStep(
				title: "wakeUp",
				color: .green,
				icon: "sunrise",
				time: todayWith(hour: 6)
			),
			ChronotypeStep(
				title: "awake",
				color: .yellow,
				icon: "sun.max",
				time: todayWith(hour: 8)
			)
		]),
	]
	
	@State var selectedChronotype = ChronotypeRoutine(title: "default", steps: [
		ChronotypeStep(
			title: "asleep",
			color: .blue,
			icon: "moon.zzz",
			time: todayWith(hour: 1)
		),
		ChronotypeStep(
			title: "wakeUp",
			color: .green,
			icon: "sunrise",
			time: todayWith(hour: 8, minute: 30)
		),
		ChronotypeStep(
			title: "awake",
			color: .yellow,
			icon: "sun.max",
			time: todayWith(hour: 10, minute: 30)
		),
		ChronotypeStep(
			title: "windDown",
			color: .orange,
			icon: "sunset",
			time: todayWith(hour: 23)
		),
	])
	
	var body: some View {
		let steps = selectedChronotype.steps

		Group {
			VStack {
				HStack {
					Text("chronotype")
						.font(.headline)
					Spacer()
				}
				HStack {
					ForEach(defaultChronotypes) { type in
						ChronotypePresetButton(
							chronotype: type,
							selectedChronotype: $selectedChronotype
						)
					}
				}
				
//				SLOW: (handles insertion, other stuff)
//				List(steps.indices, id: \.self) { stepIndex in
//					let nextIndex = stepIndex + 1 < steps.count
//						? stepIndex + 1
//						: 0
//
//					TimeRangeConfigRow(
//						title: steps[stepIndex].title,
//						color: steps[stepIndex].color,
//						start: $selectedChronotype.steps[stepIndex].time,
//						end: steps[nextIndex].time
//					).tag(steps[stepIndex])
//				}

				//	Can't combine optional + binding for some reason?
				// if let steps = selectedChronotype.steps {}
				
				// SMOOTH:
				ForEach(steps.indices, id: \.self) { stepIndex in
					let nextIndex = stepIndex + 1 < steps.count
						? stepIndex + 1
						: 0
					let prevIndex = stepIndex - 1 >= 0
						? stepIndex - 1
						: steps.count - 1

					TimeRangeConfigRow(
						title: steps[stepIndex].title,
						color: steps[stepIndex].color,
						icon: steps[stepIndex].icon,
						start: $selectedChronotype.steps[stepIndex].time,
						next: steps[nextIndex].time,
						prev: steps[prevIndex].time
						
					)
				}
			}
//			TimeRangeVisualization()
		}
	}
}

// Helper to get today with hour & minute
func todayWith(hour: Int, minute: Int = 0) -> Date {
	Calendar.current.date(
		bySettingHour: hour,
		minute: minute,
		second: 0,
		of: Date()
	) ?? Date()
}

struct TimeRangeConfigRow: View {
	let title: String
	var color: Color = .red
	let icon: String?
	
	@Binding var start: Date
	var next: Date
	var prev: Date
	
	//	Computed (adds 1 day if it wraps around)
	var adjustedNext: Date {
		if next < start {
			return Calendar.current.date(
				byAdding: DateComponents(calendar: Calendar.current, day: 1), to: next
			) ?? Date()
		} else {
			return next
		}
	}
	
	//	Computed (substracts 1 day if it wraps around)
	var adjustedPrev: Date {
		if prev > start {
			return Calendar.current.date(
				byAdding: DateComponents(calendar: Calendar.current, day: -1), to: prev
			) ?? Date()
		} else {
			return prev
		}
	}
	
	var body: some View {
		let timeRangeComponents = Calendar.current.dateComponents(
			[.hour, .minute], from: start, to: adjustedNext
		)

		let timeRangeInterval = DateInterval(start: start, end: adjustedNext)
		
		HStack {
			if let icon = icon {
				Image(systemName: icon)
					.foregroundColor(color)
			}
			DatePicker("\(title) start",
				selection: $start,
				in: adjustedPrev ... adjustedNext,
				displayedComponents: [.hourAndMinute]
			)
				.frame(maxWidth: 240)
			Text("duration →")
				.foregroundColor(color)
			Text("\(timeRangeComponents.hour ?? 0)h \(timeRangeComponents.minute ?? 0)m")
			Spacer()
			Text("\(timeRangeInterval)")
				.foregroundColor(color)
		}
		.padding(8.0)
		.background(color.opacity(0.1))
	}
}

struct ChronotypePresetButton: View {
	var chronotype: ChronotypeRoutine
	
	@Binding var selectedChronotype: ChronotypeRoutine
	
	var body: some View {
		Button(action: {
			selectedChronotype = chronotype
		}) {
			Text(chronotype.title)
			if let notes = chronotype.notes {
				Text(notes)
					.foregroundColor(.secondary)
			}
		}
	}
}

struct TimeRangeVisualization: View {
	let hours: [Int] = Array(stride(from: -12, to: 36, by: 6))
	
	var body: some View {
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
