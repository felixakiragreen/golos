//
//  ButtonStyles.swift
//  FutureUI
//
//  Created by Felix Akira Green on 1/27/21.
//

import SwiftUI

// MARK: - PREVIEW
struct ButtonStyles_Previews: PreviewProvider {
	static var previews: some View {
		ButtonStyles()
			.preferredColorScheme(.light)
		
		ButtonStyles()
			.preferredColorScheme(.dark)
	}
}

struct ButtonStyles: View {
	
	// MARK: - PROPS
	
	// MARK: - BODY
	var body: some View {
		VStack(spacing: 16) {
			Button(action: {
				print("brutal")
			}, label: {
				Text("brutal")
					.font(.system(.body, design: .monospaced))
					.padding()
			})
				.buttonStyle(BrutalistButtonStyle(hue: .green))
			Button(action: {
				print("glitch")
			}, label: {
				Text("glitch")
					.padding()
			})
			.buttonStyle(GlitchButtonStyle(hue: .green))
		}
		.padding()
	}
}


// MARK: - BRUTALIST
struct BrutalistButtonStyle: ButtonStyle {
	var hue: ColorHue = .grey
	var dis: CGFloat = 3.0

	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.padding(dis * 2)
			.offset(x: configuration.isPressed ? dis : -dis, y: configuration.isPressed ? dis : -dis)
			.background(
				ZStack {
					// shadow
					Rectangle()
						.fill(ColorPreset(hue: hue, lum: .extraLight).getColor())
						.offset(x: dis, y: dis)

					// ground
					Rectangle()
						.foregroundColor(ColorPreset(hue: hue, lum: configuration.isPressed ? .light : .normal).getColor())
						.offset(x: configuration.isPressed ? dis : -dis, y: configuration.isPressed ? dis : -dis)

					// border
					Rectangle()
						.inset(by: -dis)
						.strokeBorder(ColorPreset(hue: hue, lum: configuration.isPressed ? .normal : .light).getColor(), lineWidth: 2)
						.offset(x: configuration.isPressed ? dis : -dis, y: configuration.isPressed ? dis : -dis)
				}
			)
			.foregroundColor(ColorPreset(hue: hue, lum: .dark).getColor())
			.animation(.spring(response: 0))
	}
}

// MARK: - GLITCH

struct GlitchButtonStyle: ButtonStyle {
	var hue: ColorHue = .grey
	var dis: CGFloat = 1.0
	
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.background(
				ZStack {
					// ground
					Rectangle()
						.foregroundColor(ColorPreset(lum: configuration.isPressed ? .light : .nearWhite).getColor())
					
					// border
					Rectangle()
						.inset(by: -3 * dis)
						.strokeBorder(ColorPreset(hue: .yellow, lum: .extraLight).getColor(), lineWidth: dis)
					
					Rectangle()
						.inset(by: -2 * dis)
						.strokeBorder(ColorPreset(hue: .red, lum: .extraLight).getColor(), lineWidth: dis)
					
					Rectangle()
						.inset(by: -1 * dis)
						.strokeBorder(ColorPreset(hue: .blue, lum: .extraLight).getColor(), lineWidth: dis)
				}
			)
			.animation(.spring(response: 0))
	}
}
