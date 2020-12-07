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
	
	let hours = 0..<48
	let days = 0..<15
	
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
	
	// MARK: - BODY
	var body: some View {
		VStack(spacing: 8) {
			HStack {
				Text("time")
			}//: HSTACK - TIME
			
			VStack {
				VStack(alignment: .leading, spacing: 8) {
				
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
				
				
					
//					Text("days") // Replace with hour labels (can be manual for now)
					
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
							
							/*
							ForEach(hours) { item in
								Rectangle()
									.frame(width: 1.0)
									.foregroundColor(Color.gray.opacity(0.2))
							}
							*/
						}//: ZSTACK
					}
					.frame(maxHeight: .infinity)
					
				}//: DAYS
				.padding()
				.frame(maxWidth: .infinity)
				.background(
					RoundedRectangle(cornerRadius: 8, style: .circular)
						.foregroundColor(Color.gray.opacity(0.1))
				)
				
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
	}
}
