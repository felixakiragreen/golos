//
//  CircadianView.swift
//  golOS
//
//  Created by Felix Akira Green on 1/2/21.
//

import SwiftUI

// MARK: - PREVIEW
struct CircadianView_Previews: PreviewProvider {
	static var previews: some View {
		CircadianView()
			.preferredColorScheme(.dark)
	}
}

struct CircadianView: View {
	// MARK: - PROPS
	
	// MARK: - BODY
	var body: some View {
		VStack {
			thing1
				.frame(height: 90)
			
			thing2
				.frame(height: 90)
		}
		
	}
	
	var thing1: some View {
		GeometryReader { geometry in
			let width = geometry.size.width
			
			ZStack {
				HStack(spacing: 0) {
					Rectangle()
						.foregroundColor(ColorPreset(hue: .blue, lum: .normal).getColor())
						.frame(width: width * 0.25)
					Rectangle()
						.foregroundColor(ColorPreset(hue: .green, lum: .normal).getColor())
						.frame(width: width * 0.1)
					Rectangle()
						.foregroundColor(ColorPreset(hue: .yellow, lum: .normal).getColor())
						.frame(width: width * 0.5)
					Rectangle()
						.foregroundColor(ColorPreset(hue: .orange, lum: .normal).getColor())
						.frame(width: width * 0.15)
				}
				
				Rectangle()
					.fill(
						LinearGradient(gradient:
							Gradient(stops: [
								Gradient.Stop(
									color: ColorPreset(hue: .blue, lum: .normal).getColor(),
									location: 0.125
								),
								Gradient.Stop(
									color: ColorPreset(hue: .green, lum: .normal).getColor(),
									location: 0.375
								),
								Gradient.Stop(
									color: ColorPreset(hue: .yellow, lum: .normal).getColor(),
									location: 0.575
								),
								Gradient.Stop(
									color: ColorPreset(hue: .orange, lum: .normal).getColor(),
									location: 0.875
								),
							]),
							startPoint: .leading,
							endPoint: .trailing
						)
					)
					.opacity(0.25)
				
			}
		}//: Geometry
		.background(ColorPreset(hue: .grey, lum: .normal).getColor())
	}
	
	var thing2: some View {
		GeometryReader { geometry in
			let width = geometry.size.width
			
			ZStack {
				HStack(spacing: 0) {
					Hexagon(.flat, head: false, body: .infinity, full: true)
						.fill(ColorPreset(hue: .blue, lum: .normal).getColor())
						.frame(width: width * 0.2)
//					Hexagon(.flat, head: false, body: 0, full: true)
//						.fill(ColorPreset(hue: .blue, lum: .normal).getColor())
//						.frame(width: 40)
					Rectangle()
						.fill(Color.clear)
//						.foregroundColor(ColorPreset(hue: .green, lum: .normal).getColor())
						.frame(width: width * 0)
					Hexagon(.flat, body: .infinity)
						.fill(ColorPreset(hue: .yellow, lum: .normal).getColor())
//					Rectangle()
//						.foregroundColor(ColorPreset(hue: .yellow, lum: .normal).getColor())
						.frame(width: width * 0.65)
					Rectangle()
						.fill(Color.clear)
//						.foregroundColor(ColorPreset(hue: .orange, lum: .normal).getColor())
						.frame(width: width * 0.15)
				}.zIndex(2)
				
				Rectangle()
					.fill(
						LinearGradient(gradient:
							Gradient(stops: [
								Gradient.Stop(
									color: ColorPreset(hue: .blue, lum: .normal).getColor(),
									location: 0
								),
								Gradient.Stop(
									color: ColorPreset(hue: .green, lum: .normal).getColor(),
									location: 0.375
								),
								Gradient.Stop(
									color: ColorPreset(hue: .yellow, lum: .normal).getColor(),
									location: 0.575
								),
								Gradient.Stop(
									color: ColorPreset(hue: .orange, lum: .normal).getColor(),
									location: 0.875
								),
							]),
							startPoint: .leading,
							endPoint: .trailing
						)
					)
//					.opacity(0.25)
				
			}
		}//: Geometry
		.background(ColorPreset(hue: .grey, lum: .normal).getColor())
	}
}
