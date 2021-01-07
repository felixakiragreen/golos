//
//  SolarView.swift
//  golOS (iOS)
//
//  Created by Felix Akira Green on 1/5/21.
//

import SwiftUI

struct SolarView: View {
	let Sun = SunCalc()
	
	var lat = 39.856672
	var lng = -86.132480
	
	var body: some View {
		
		let times = Sun.getTimes(date: Date(), lat: lat, lng: lng)
		
		VStack {
//			Text("Hello, World!")
			Button("test") {
				print("asdf")
				print(times)
			}
			.foregroundColor(.primary)
			.padding()
			.background(
				Hexagon(.flat, body: .infinity)
//					.frame(maxWidth: .infinity)
					.foregroundColor(.secondary)
			)
//			.frame(maxWidth: .infinity)
		}
		.onAppear {
			print("asdf")
			
		}
	}
}

struct SolarView_Previews: PreviewProvider {
	static var previews: some View {
		SolarView()
			.preferredColorScheme(.dark)
	}
}
