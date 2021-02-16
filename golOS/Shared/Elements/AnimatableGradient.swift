//
//  AnimateableGradient.swift
//  golOS
//
//  Created by Felix Akira Green on 2/16/21.
//

import SwiftUI

typealias NativeStop = (color: NativeColor, location: CGFloat)

struct AnimatableGradient: AnimatableModifier {
	
	let all: [[NativeStop]]
	let fromIndex: Int
	let toIndex: Int
	var pct: CGFloat = 0
	
	var animatableData: CGFloat {
		get { pct }
		set { pct = newValue }
	}
	
	func body(content: Content) -> some View {
		var gStops = [Gradient.Stop]()
		
		if let from: [NativeStop] = all[optional: fromIndex],
			let to: [NativeStop] = all[optional: toIndex] {
			
			for i in from.indices {
				gStops.append(
					Gradient.Stop(
						color: colorMixer(c1: from[i].color, c2: to[i].color, pct: pct),
						location: stopMixer(s1: from[i].location, s2: to[i].location, pct: pct)
					)
				)
			}
		}
		
		return LinearGradient(
			gradient: Gradient(stops: gStops),
			startPoint: .top,
			endPoint: .bottom
		)
	}
	
	// This is a very basic implementation of a color interpolation
	// between two values.
	func colorMixer(c1: NativeColor, c2: NativeColor, pct: CGFloat) -> Color {
		guard let cc1 = c1.cgColor.components else { return Color(c1) }
		guard let cc2 = c2.cgColor.components else { return Color(c1) }
		
		let r = (cc1[0] + (cc2[0] - cc1[0]) * pct)
		let g = (cc1[1] + (cc2[1] - cc1[1]) * pct)
		let b = (cc1[2] + (cc2[2] - cc1[2]) * pct)
		
		return Color(red: Double(r), green: Double(g), blue: Double(b))
	}
	
	func stopMixer(s1: CGFloat, s2: CGFloat, pct: CGFloat) -> CGFloat {
		s1 + (s2 - s1) * pct
	}
}
