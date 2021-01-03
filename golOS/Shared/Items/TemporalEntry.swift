//
//  TemporalEntry.swift
//  golOS
//
//  Created by Felix Akira Green on 1/3/21.
//

import SwiftUI

struct TemporalEntry: View {
	
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
	
	var body: some View {
		ZStack {
			grid
//				.opacity(0.2)

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
							print(gesture)
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
//		.background(Color.red)
	}
	
	var grid: some View {
		
		let hCount = 0..<6
		let vCount = 0..<10
		let size: CGFloat = snapIncrement * 2
		
		let hGrid = HStack(spacing: 0) {
			ForEach(hCount, id: \.self) { _ in
				Rectangle()
					.fill(Color.clear)
//					.border(Color.primary)
					.frame(width: size, height: size)
					.overlay(Divider(), alignment: .leading)
					.overlay(Divider())
//					.overlay(Divider(), alignment: .trailing)
//					.overlay(
//						VStack(spacing: 0) {
//							HStack(spacing: 0) {
//								Rectangle()
//									.fill(Color.clear)
////									.border(Color.secondary)
//								Rectangle()
//									.fill(Color.clear)
////									.border(Color.secondary)
//							}
//							HStack(spacing: 0) {
//								Rectangle()
//									.fill(Color.clear)
////									.border(Color.secondary)
//								Rectangle()
//									.fill(Color.clear)
////									.border(Color.secondary)
//							}
//						}.opacity(0.5)
//					)
			}
		}
		
		
		return VStack(spacing: 0) {
			ForEach(vCount, id: \.self) { _ in
				hGrid
			}
		}
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

struct TemporalEntry_Previews: PreviewProvider {
	static var previews: some View {
		TemporalEntry()
	}
}
