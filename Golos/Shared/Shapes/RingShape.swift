//
//  RingShape.swift
//  Golos
//
//  Created by Felix Akira Green on 11/6/20.
//

import SwiftUI

struct RingShape: Shape {
	
//	private var percent: Double = 100
//	private var startAngle: Angle = .degrees(0)
//	private let drawnClockwise: Bool = false
	
	var percent: Double = 100
	var startAngle: Angle = .degrees(0)
	var drawnClockwise: Bool = true
	
	// 2. This allows animations to run smoothly for percent values
	var animatableData: Double {
		get {
			return percent
		}
		set {
			percent = newValue
		}
	}
	
//	init(
//		percent: Double = 100,
//		startAngle: Angle = .degrees(0),
//		drawnClockwise: Bool = false
//	) {
//		self.percent = percent
//		self.startAngle = startAngle
//		self.drawnClockwise = drawnClockwise
//	}
	
	// 3. This draws a simple arc from the start angle to the end angle
	func path(in rect: CGRect) -> Path {
		let rotationAdjustment = Angle.degrees(90)
		let modifiedStartAngle = startAngle - rotationAdjustment
		
		let endAngle = Angle(
			degrees: RingShape.percentToAngle(
				percent: percent,
				startAngle: modifiedStartAngle
			)
		)
		
		return Path { path in
			path.addArc(
				center: CGPoint(x: rect.midX, y: rect.midY),
				radius: min(rect.width, rect.height) / 2,
				startAngle: modifiedStartAngle,
				endAngle: endAngle,
				clockwise: !drawnClockwise
			)
		}
	}
	
	// Helper function to convert percent values to angles in degrees
	static func percentToAngle(percent: Double, startAngle: Angle) -> Double {
		(percent / 100 * 360) + startAngle.degrees
	}
}

struct RingShape_Previews: PreviewProvider {
	static var previews: some View {
		RingShape(percent: 60)
			.stroke(style: StrokeStyle(lineWidth: 50, lineCap: .round))
			.fill(Color.green)
			.frame(width: 300, height: 300)
	}
}
