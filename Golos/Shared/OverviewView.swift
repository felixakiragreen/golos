//
//  Overview.swift
//  Golos
//
//  Created by Felix Akira Green on 11/1/20.
//

import SwiftUI

struct Overview: View {
	var body: some View {
		VStack {
			VStack {
				TimeBlocker()
//				PlannerView()
//				TimelineView()
//				HolisticView()
			}
		}
		.navigationTitle("Overview")
		.frame(
			minWidth: 640,
			idealWidth: 1200,
			maxWidth: .infinity,
			minHeight: 480,
			idealHeight: 800,
			maxHeight: .infinity
		)
	}
}

struct AnimationExperiment: View {
	@State var percentValue: Double = 20

	var body: some View {
		HStack {
			SquareBrick(percent: percentValue)
				.frame(width: 20, height: 20)
			Slider(value: $percentValue, in: 0...100)

			Button("Random Progress", action: {
				withAnimation {
					let newPercent = Double.random(in: 0...100)
					percentValue = newPercent
				}
			})
		}
	}
}

struct Overview_Previews: PreviewProvider {
	static var previews: some View {
		Overview()
	}
}
