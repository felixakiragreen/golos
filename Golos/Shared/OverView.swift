//
//  WarRoomView.swift
//  Golos
//
//  Created by Felix Akira Green on 11/1/20.
//

import SwiftUI

struct OverView: View {
	@State var percentValue: Double = 20
	
	var body: some View {
		VStack {
			VStack {
				Spacer()
				HStack {
					Text("Past")
					Text("Present")
					Text("Future")
					
					SquareBrick(percent: percentValue)
						.frame(width: 20, height: 20)
				}
				Spacer()
//				.frame(
//					maxWidth: .infinity,
//					maxHeight: .infinity
//				)
				
				Slider(value: $percentValue, in: 0...100)
				
				Button("Random Progress", action: {
					withAnimation {
						let newPercent = Double.random(in: 0...100)
						percentValue = newPercent
					}
				})
//					.onTapGesture {
//					let newPercent = CGFloat.random(in: 0...100)
//					print(newPercent)
//					self.percentValue = newPercent
//				}
				
				TimelineView()
				Spacer()
				HStack {
					Text("Objectives")
					Text("Chracter")
					Text("Metrics")
				}
				Spacer()
//				.frame(
//					maxWidth: .infinity,
//					maxHeight: .infinity
//				)
			}
			.frame(
				maxWidth: .infinity,
				maxHeight: .infinity
			)
		}
		.navigationTitle("Overview")
		.frame(
			minWidth: 640,
			idealWidth: 1200,
			maxWidth: .infinity,
			minHeight: 480,
			idealHeight: 800,
			maxHeight: .infinity
//			alignment: .leading
		)
	}
}

struct OverView_Previews: PreviewProvider {
	static var previews: some View {
		OverView()
	}
}
