//
//  TemporalView.swift
//  golOS layout
//
//  Created by Felix Akira Green on 12/7/20.
//

import SwiftUI
import Sliders

struct TemporalView: View {
	// MARK: - PROPERTIES
	
	let pentaminutes = 0 ..< Int(60 / 5 * 24)

	let hourLabels = [
		("12:00","-24h"),
		("18:00",""),
		("00:00","-12h"),
		("06:00",""),
		("12:00",""),
		("18:00",""),
		("00:00","+12h"),
		("06:00",""),
		("12:00","+24h"),
	]
	
	@State var zoomRadius = 2.0
	@State var zoomLevel = 1.0
	
	@State var value = 0.5
	@State var range = 10.0...50.0
	@State var x = 0.5
	@State var y = 0.5
	
	// MARK: - BODY
	var body: some View {
		VStack(spacing: 8) {
			HStack {
				Text("time")
			}//: HSTACK - TIME
			
			VStack {
				VStack(alignment: .leading, spacing: 8) {
					/* // labels
					GeometryReader { geometry in
						let labelWidth = geometry.size.width / 8
						HStack(spacing: 0) {
							HStack {
								Text("12:00")
									.font(.caption)
									.foregroundColor(Color.gray)
									.frame(maxWidth: .infinity, alignment: .leading)
							}
							.frame(width: labelWidth / 2)

							HStack {
								Text("18:00")
									.font(.caption)
									.foregroundColor(Color.gray)
							}
							.frame(width: labelWidth)
							
							HStack {
								Text("00:00")
									.font(.caption)
							}
							.frame(width: labelWidth)
							
							HStack {
								Text("06:00")
									.font(.caption)
							}
							.frame(width: labelWidth)
							
							HStack {
								Text("12:00")
									.font(.caption)
							}
							.frame(width: labelWidth)
							
							HStack {
								Text("18:00")
									.font(.caption)
							}
							.frame(width: labelWidth)
							
							HStack {
								Text("00:00")
									.font(.caption)
							}
							.frame(width: labelWidth)
							
							HStack {
								Text("06:00")
									.font(.caption)
									.foregroundColor(Color.gray)
							}
							.frame(width: labelWidth)
							
							HStack {
								Text("12:00")
									.font(.caption)
									.foregroundColor(Color.gray)
									.frame(maxWidth: .infinity, alignment: .trailing)
							}
							.frame(width: labelWidth / 2)
						
						}//: HSTACK
					}//: LABEL
					.frame(height: 13)
					*/
					
					VStack {
						// TODO: move this to TimelineConfigurationView
						HStack {

							// zoom "RADIUS"
							Slider(value: $zoomRadius, in: 0 ... 6, step: 0.5) {
								Text("zoomRadius \(zoomRadius, specifier: "%.2f")")
							}
							.frame(width: 300)
							
							// zoom "LEVEL"
							Slider(value: $zoomLevel, in: 0 ... 4, step: 1) {
								Text("zoomLevel \(zoomLevel, specifier: "%.2f")")
							}
							.frame(width: 200)
							// TODO: remove
							
							Spacer()
							
							
							
						}
						Group {
							Text("value \(value, specifier: "%.2f")")
							Text("range.lower \(range.lowerBound, specifier: "%.2f") range.upper \(range.upperBound, specifier: "%.2f")")
							Text("x \(x, specifier: "%.2f")")
							Text("y \(y, specifier: "%.2f")")
						}
//						ValueSlider(value: $value)
//						RangeSlider(range: $range, in: pentaminutes, step: 1.0, onEditingChanged: () -> {})
//						PointSlider(x: $x, y: $y)
					}
					
					HStack {
						
						ZStack {
							
							TimelineTrack(
								zoomLevel: zoomLevel,
								zoomUnits: [
									ZoomingUnits(
										space: .hour,
										nano: .halfday,
										micro: .day
									),
									ZoomingUnits(
										space: .quarterhour,
										nano: .hour,
										micro: .hexahour,
										mezzo: .day
									),
									ZoomingUnits(
										space: .pentaminute,
										nano: .quarterhour,
										micro: .hour,
										mezzo: .hexahour,
										major: .day
									),
									ZoomingUnits(
										space: .pentaminute,
										nano: .quarterhour,
										micro: .hour,
										mezzo: .hexahour,
										major: .day
									),
								],
								interval: IntervalConfig(
									unit: .pentaminute,
									count: pentaminutes.count,
									radius: CGFloat(zoomRadius)
								)
							)
//							.frame(height: 40)
							
							TimelineBlock()
							
						}//: ZSTACK - Scaling wrapper
//						.frame(maxWidth: .infinity)
//						.animation(.easeInOut)
//						.gesture(
//							DragGesture()
//								.onChanged { gestureValue in
//									print(gestureValue)
//								}
//								.onEnded { gestureValue in
//									print(gestureValue)
//								}
//						)
//						.gesture(
//							Hover
//						)
//						.onHover(perform: { hovering in
//							/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
//						})
						// .drawingGroup()

					}//: SCROLLVIEW
					

				}//: DAYS
				.padding()
//				.frame(maxWidth: .infinity)
				.background(
					RoundedRectangle(cornerRadius: 8, style: .circular)
						.foregroundColor(Color.gray.opacity(0.1))
				)

			}//: VSTACK
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			
		}//: VSTACK - ALL
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding()
	}
}

// MARK: - PREVIEW
struct TemporalView_Previews: PreviewProvider {
	static var previews: some View {
		TemporalView()
			.preferredColorScheme(.dark)
	}
}
