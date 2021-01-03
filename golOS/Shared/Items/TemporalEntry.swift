//
//  TemporalEntry.swift
//  golOS
//
//  Created by Felix Akira Green on 1/3/21.
//

import SwiftUI

/**
TODO:
- add Major, Mezzo, Minor, Micro, Origin lines (offseting them from origin, using ZStack)
- add haptics: heavy for major, medium mezzo, light for minor & micro
		make them lighter like the native timer picker

- FIX BUG WITH negative time (lower left quadrant)
- major, mezzo, minor, micro colors?

COMPLETELY ALTERNATE IDEA

you're not dragging the ball, YOU'RE DRAGGING THE GRID BEHIND THE BALL

It would allow for inertia to be a much more realistic component

so you just start dragging the little time clock thing
	then the grid appears, with the selected time (+h:m)
	then you can drag anywhere on the grid
	then you double tap (anywhere, the grid) to "be done"
	grid disappears, new time is selected
		would be fun if the grid got blasted away when you double-tap to be done
	boom, done



*/

// MARK: - PREVIEW
struct TemporalEntry_Previews: PreviewProvider {
	static var previews: some View {
		TemporalEntry()
//			.preferredColorScheme(.dark)
	}
}


struct TemporalEntry: View {
	// MARK: - PROPS
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@State private var dragOffset: CGSize = .zero
//	@State private var dragSnap: CGSize = .zero
	
	@State private var selectedTime: Date = Date().round(precision: minutes(5))
	
	let snapIncrement: CGFloat = 30
	let xTimeIncrement: Double = minutes(5)
	let yTimeIncrement: Double = minutes(30)
	
	var dragSnap: CGSize {
		let w = round(dragOffset.width / snapIncrement) * snapIncrement
		let h = round(dragOffset.height / snapIncrement) * snapIncrement
		return CGSize(width: w, height: h)
	}
	
	var previewTime: Date {
		return selectedTime.addingTimeInterval(calculateTimeInterval(selectedTime))
	}
	
	// MARK: - BODY
	var body: some View {
		ZStack {
			grid2

			Text("x:\(dragOffset.width, specifier: "%.1f") y:\(dragOffset.height, specifier: "%.1f")")
//				.offset(x: 0, y: 0)
			Text("x:\(dragSnap.width, specifier: "%g") y:\(dragSnap.height, specifier: "%g")")
				.offset(x: 0, y: -40)
			
			Rectangle()
				.stroke(Color("orange.400"), lineWidth: 4)
				.frame(width: snapIncrement * 2, height: snapIncrement * 2)
				.offset(dragSnap)
				.zIndex(2)
				.opacity(0.5)
			Circle()
				.frame(width: snapIncrement * 2, height: snapIncrement * 2)
				.foregroundColor(Color("green.400"))
				.offset(dragOffset)
				.gesture(
					DragGesture()
						.onChanged { gesture in
//							print(gesture)
							self.dragOffset = gesture.translation
						}
						.onEnded { _ in
							withAnimation(.spring()) {
								self.selectedTime = self.previewTime
								self.dragOffset = .zero
							}
						}
				)
			
			ZStack(alignment: .top) {
				VStack {
					Text("\(previewTime, formatter: Self.timeFormatter)")
						.font(.largeTitle)
					HStack {
						let minutes = calculateTimeInterval(selectedTime) / 60
						let hours = floor(minutes / 60)
						let minutesRemaining = minutes.truncatingRemainder(dividingBy: 60)
						
						if abs(minutes) > 0 {
							Text("\(minutes, specifier: "%g")min")
						}
						
						if abs(hours) > 0 {
							Text(" or ")
							Text("\(hours, specifier: "%g")h")
							if abs(minutesRemaining) > 0 {
								Text("\(abs(minutesRemaining), specifier: "%g")m")
							}
						}
					}
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
			
		}//: ZStack
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.onChange(of: dragSnap) { [dragSnap] newValue in
			print("old", dragSnap)
			print("new", newValue)
//			if let update = self.onChange {
//				update(opt)
//			}
		
			if newValue.height != dragSnap.height {
				if abs(newValue.height.truncatingRemainder(dividingBy: snapIncrement * 2)) == 0 {
					UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
				} else {
					UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
				}
			} else if newValue.width != dragSnap.width {
				if abs(newValue.width.truncatingRemainder(dividingBy: snapIncrement * 2)) == 0 {
					UIImpactFeedbackGenerator(style: .soft).impactOccurred()
				} else {
					UIImpactFeedbackGenerator(style: .light).impactOccurred()
				}
			}
			
			// let impactMed = UIImpactFeedbackGenerator(style: .medium)
			//	impactMed.impactOccurred()
			//.medium with .soft, .light, .heavy, or .rigid
		
		}
	}
	
	// MARK: - GRID
	var grid: some View {
		
		let hCount = 0..<6
		let vCount = 0..<10
		let size: CGFloat = snapIncrement * 2
		
		let hGrid = HStack(spacing: 0) {
			ForEach(hCount, id: \.self) { _ in
				Rectangle()
					.fill(Color.clear)
					.border(Color.primary)
					.frame(width: size, height: size)
					.overlay(
						VStack(spacing: 0) {
							HStack(spacing: 0) {
								Rectangle()
									.fill(Color.clear)
									.border(Color.secondary)
								Rectangle()
									.fill(Color.clear)
									.border(Color.secondary)
							}
							HStack(spacing: 0) {
								Rectangle()
									.fill(Color.clear)
									.border(Color.secondary)
								Rectangle()
									.fill(Color.clear)
									.border(Color.secondary)
							}
						}.opacity(0.5)
					)
			}
		}
		
		
		return VStack(spacing: 0) {
			ForEach(vCount, id: \.self) { _ in
				hGrid
			}
		}.opacity(0.2)
	}

	
	var grid2: some View {
		
		let hCount = 1..<4
		let vCount = 1..<6
		let size: CGFloat = snapIncrement * 2
		
		return ZStack {
			Rectangle()
				.frame(width: 1.0)
				.foregroundColor(Color("red.sys.400"))
			Rectangle()
				.frame(height: 1.0)
				.foregroundColor(Color("red.sys.400"))
			ForEach(vCount, id: \.self) { j in
				MajorVLine()
					.offset(x: 0, y: size * CGFloat(j))
				MajorVLine()
					.offset(x: 0, y: size * -CGFloat(j))
				MezzoVLine()
					.offset(x: 0, y: size * CGFloat(j) - size / 2)
				MezzoVLine()
					.offset(x: 0, y: size * -CGFloat(j) + size / 2)
			}
			ForEach(hCount, id: \.self) { k in
				MinorHLine()
					.offset(x: size * CGFloat(k), y: 0)
				MinorHLine()
					.offset(x: size * -CGFloat(k), y: 0)
				MicroHLine()
					.offset(x: size * CGFloat(k) - size / 2, y: 0)
				MicroHLine()
					.offset(x: size * -CGFloat(k) + size / 2, y: 0)
			}
		}
		.blendMode(colorScheme == ColorScheme.dark ? .lighten : .darken)
		
	}
	
	func calculateTimeInterval(_ current: Date) -> TimeInterval {
		let x = dragSnap.width / snapIncrement
		let y = dragSnap.height / snapIncrement
		
//		print(x)
//		print(y)
		
		let timeToAdd = (Double(x) * xTimeIncrement) + (Double(y) * yTimeIncrement * -1)
		
//		print(timeToAdd)
		
		return timeToAdd
	}
	
	static let timeFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		return formatter
	}()
}


// NEW GRID SHOULD USE LAZYHSTACK, &c.


// MARK: - SUBVIEWS

struct MajorVLine: View {
	var body: some View {
		Rectangle()
			.frame(height: 4.0)
			.foregroundColor(Color("grey.sys.400"))
	}
}

struct MezzoVLine: View {
	var body: some View {
		Rectangle()
			.frame(height: 3.0)
			.foregroundColor(Color("grey.sys.300"))
	}
}

struct MinorHLine: View {
	var body: some View {
		Rectangle()
			.frame(width: 2.0)
			.foregroundColor(Color("grey.sys.300"))
			
	}
}

struct MicroHLine: View {
	var body: some View {
		Rectangle()
			.frame(width: 1.0)
			.foregroundColor(Color("grey.sys.200"))
	}
}