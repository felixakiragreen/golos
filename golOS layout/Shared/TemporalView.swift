//
//  TemporalView.swift
//  golOS layout
//
//  Created by Felix Akira Green on 12/7/20.
//

import SwiftUI
import Shapes

struct TemporalView: View {
	// MARK: - PROPERTIES
	
	let pentaminutes = 0 ..< Int(60 / 5 * 48)
	let hours = 0 ..< 48 + 1
	let days = 0 ..< 7 + 1 + 7 + 1
	
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
	
	@State var zoomRadius = 1.0
	@State var zoomLevel = 1.0
	
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
					
					HStack {

						// zoom "RADIUS"
						Slider(value: $zoomRadius, in: 0 ... 6, step: 0.5) {
							Text("zoomRadius \(zoomRadius, specifier: "%.2f")")
						}
						.frame(width: 300)
						
						Slider(value: $zoomLevel, in: 0 ... 4, step: 1) {
							Text("zoomLevel \(zoomLevel, specifier: "%.2f")")
						}
						.frame(width: 200)
						// TODO: remove
						
						Spacer()
						
						// zoom "LEVEL"
					}
					
					
//					Button("Scroll to bottom") {
//								  withAnimation {
//										scrollView.scrollTo(99, anchor: .center)
//								  }
//							 }

//						{ offset in
//							print(offset)
//						}
//					ScrollView(.horizontal, showsIndicators: true, offsetChanged: { print($0) }) {
//					ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, content: {
//						/*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
//					})
					
					ScrollView(.horizontal) {
						
						VStack(alignment: .leading) {
							
							HStack(alignment: .bottom, spacing: CGFloat(floor(zoomLevel * 8.0))) {
								ForEach(hours) { idx in
									RoundedRectangle(cornerRadius: 1, style: .circular)
										.frame(
											width: idx % 6 == 0 ? 3.0 : 1.0,
											height: idx % 6 == 0 ? 16 : 8
										)
										//								.offset(x: 1.0 * CGFloat(idx), y: 0)
										.foregroundColor(Color.gray.opacity(idx % 6 == 0 ? 0.75 : 0.3))
								}
							}
							
							TimeScalingGridView(
								intervals: pentaminutes, zoomLevel: zoomLevel
							)
							.frame(height: 40)
							
							TimeScalingGridView2(
								zoomLevel: zoomLevel,
								zoomUnits: [
									ZoomingUnits(
										space: .hour,
										nano: .halfday,
										major: .day
									),
									ZoomingUnits(
										space: .quarterhour,
										nano: .hour,
										micro: .hexahour,
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
							.frame(height: 40)
						}
						.frame(maxWidth: .infinity)
						.animation(.easeInOut)
//						.drawingGroup()
					}
					
//					Text("days") // Replace with hour labels (can be manual for now)
					
					/*
					VStack {
						ZStack {
							// REDO
							HStack(spacing: 0) {
								Color.clear
								Color.gray
								Color.gray
								Color.clear
							}
							.opacity(0.1)
							
							GridPattern(verticalLines: 49)
								.stroke(Color.gray.opacity(0.1), style: .init(lineWidth: 1, lineCap: .round))
							GridPattern(verticalLines: 9)
								.stroke(Color.gray.opacity(0.25), style: .init(lineWidth: 2, lineCap: .round))
							GridPattern(verticalLines: 5)
								.stroke(Color.gray.opacity(0.5), style: .init(lineWidth: 3, lineCap: .round))
	//							.background(Color.gray.opacity(0.1))
							
						}//: ZSTACK
					}
					.frame(maxHeight: .infinity)
					*/

				}//: DAYS
				.padding()
				.frame(maxWidth: .infinity)
				.background(
					RoundedRectangle(cornerRadius: 8, style: .circular)
						.foregroundColor(Color.gray.opacity(0.1))
				)

				/*
				VStack {
					VStack {
						Text("weeks")
						HStack {
							ForEach(days) { item in
								Rectangle()
									.frame(width: 1.0)
									.foregroundColor(Color.gray.opacity(0.2))
							}
						}
						.frame(maxWidth: .infinity)
					}
					.frame(maxWidth: .infinity)
				}//: WEEKS
				.frame(maxWidth: .infinity)
				*/

			}//: VSTACK
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			
		}//: VSTACK - ALL
		.frame(maxWidth: .infinity, maxHeight: .infinity)
//		.padding()
	}
}

// MARK: - PREVIEW
struct TemporalView_Previews: PreviewProvider {
	static var previews: some View {
		TemporalView()
			.preferredColorScheme(.dark)
	}
}

struct TimeScalingGridView: View {
	let intervals: Range<Int>
	let zoomLevel: Double
	
	var body: some View {
		HStack(spacing: 0) {
			//	CGFloat(floor(zoomLevel * 2.0))
			ForEach(intervals) { idx in
				// TODO: conditionally display the grid lines
				// based on zoom level
				// and the interval
				
				let h = 60/5
				let onTheQuarter = idx % 3 == 0
				let onTheHour = idx % h == 0
				let onTheHexahour = idx % (6*h) == 0
				let onTheDay = idx % (24*h) == 12*h
				
				let major = (zoomLevel >= 2 && onTheDay) || (zoomLevel >= 3 && onTheHexahour)
				let mezzo = (zoomLevel >= 1 && onTheDay) || (zoomLevel >= 2 && onTheHexahour) || (zoomLevel >= 3 && onTheHour)
				let micro = onTheDay || (zoomLevel >= 1 && onTheHexahour) || (zoomLevel >= 2 && onTheHour) || (zoomLevel >= 3 && onTheQuarter)
				let nano = onTheHexahour || (zoomLevel >= 1 && onTheHour) || (zoomLevel >= 2 && onTheQuarter) || zoomLevel >= 3
				let space = onTheHour || (zoomLevel >= 1 && onTheQuarter) || zoomLevel >= 2
				
				let spaceWidth: CGFloat = {
					switch true {
					case (idx == intervals.count - 1):
						return 0.0
					case major || mezzo || micro || nano || space:
						return CGFloat(floor(zoomLevel * 3.0) + 1)
					default:
						// hidden
						return 0.0
					}
				}()
				
				let lineWidth: CGFloat = {
					switch true {
					case major:
						return 5.0
					case mezzo:
						return 3.0
					case micro || nano:
						return 1.0
					default:
						// hidden
						return 0.0
					}
				}()
				
//				let lineHeight: CGFloat = {
//					switch true {
//					case major:
//						return 100
//					case mezzo:
//						return 100
//					case micro:
//						return 50
//					case nano:
//						return 25
//					case space:
//						return 100
//					default:
//						// hidden
//						return 0
//					}
//				}()
//
//				let lineColor: Color = {
//					switch true {
//					case major:
//						return Color.green
//					case mezzo:
//						return Color.red
//					case micro:
//						return Color.blue
//					case nano:
//						return Color.purple
//					default:
//						return Color.gray
//					}
//				}()
				
				let lineOpacity: Double = {
					switch true {
					case major:
						return 1.0
					case mezzo:
						return 0.5
					case micro:
						return 0.25
					case nano:
						return 0.125
					default:
						return 0
					}
				}()
				
				Rectangle()
					.frame(
						width: lineWidth
//						height: 100
					)
					.foregroundColor(Color.primary.opacity(lineOpacity))
				Rectangle()
					.frame(
						width: spaceWidth
//						height: 100
					)
					.foregroundColor(Color.gray.opacity(0.0))
			}
		}
	}
}


enum TimeUnit: Int {
	case pentaminute = 5
	case decaminute = 10
	case quarterhour = 15
	case icosaminute = 20
	case halfhour = 30
	case hour = 60
	case dihour = 120
	case tetrahour = 240
	case hexahour = 360
	case octahour = 480
	case halfday = 720
	case day = 1440
}

// TODO: add week, month, year, pentad, decade, quarter cent, half cent, cent

struct ZoomingUnits {
	// TODO: insert guards requiring nano < micro < mezzo < major
	var space: TimeUnit
	var nano: TimeUnit?
	var micro: TimeUnit?
	var mezzo: TimeUnit?
	var major: TimeUnit?
}

struct IntervalConfig {
	var unit: TimeUnit // smallest unit of precision
	var count: Int // number of units
	var radius: CGFloat // width of the smallest unit
}

enum LineType {
	case none, nano, micro, mezzo, major
}

struct TimeScalingGridView2: View {
	let zoomLevel: Double // 0.0 - 4.0
	let zoomUnits: [ZoomingUnits] // zoom configuration
	let interval: IntervalConfig

	var body: some View {
		
		let currentZoomIndex = min(Int(floor(zoomLevel)), zoomUnits.count - 1)
		let zoom = zoomUnits[currentZoomIndex]

		let totalMinutes = interval.count * interval.unit.rawValue
		let spacedSegments = Int(totalMinutes / zoom.space.rawValue) + 1
		
//		TODO: doesn't handle offset lul
		
		HStack(spacing: 1) {
//			Text("\(totalMinutes)  ")
//			Text("\(spacedSegments)  ")
			ForEach(0 ..< spacedSegments, id: \.self) { idx in
				
				let whichLine = TimeScalingGridView2.renderWhichLine(zoom: zoom, index: idx, intervalUnit: zoom.space.rawValue)
				
				// line
				if whichLine == .major {
					MajorLine()
				} else if whichLine == .mezzo {
					MezzoLine()
				} else if whichLine == .micro {
					MicroLine()
				} else if whichLine == .nano {
					NanoLine()
				}
				
				// space
				Rectangle()
					.frame(width: interval.radius * 3)
					.foregroundColor(Color.gray.opacity(0.1))
//					.overlay(
//						Text("\(idx)")
//							.font(.caption)
//					)
			}
		}
	}

	static func renderWhichLine(
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
}


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
