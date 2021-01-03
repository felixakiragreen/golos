//
//  ExperienceView.swift
//  golOS
//
//  Created by Felix Akira Green on 1/2/21.
//

import SwiftUI

// MARK: - PREVIEW
struct ExperienceView_Previews: PreviewProvider {
	static var previews: some View {
		ExperienceView()
			.preferredColorScheme(.dark)
	}
}

struct ExperienceView: View {
	// MARK: - PROPS
	
	// MARK: - BODY
	var body: some View {
		VStack {
			HStack {
				HStack {
					Text("level")
						.foregroundColor(Color.secondary)
					Text("1")
						.font(.headline)
				}
				Spacer()
				HStack {
					Text("xp")
						.foregroundColor(Color.secondary)
					Text("420")
					Text("/")
						.foregroundColor(Color.secondary)
					Text("1.0k")
				}
			} //: HStack
			.padding(.horizontal)
			
			Group {
				bar1
				bar2
				bar3
				bar4
				bar5
				bar6
				bar7
				bar8
				bar9
			} //: Group
			.padding()
		} //: VStack
		.padding()
	}
	
	var bar1: some View {
		ZStack {
			Hexagon(.flat, body: .infinity)
				.fill(Color("grey.sys.300"))
				.frame(height: 16)
				.overlay(
					Hexagon(.flat, body: .infinity)
						.strokeBorder(Color("grey.sys.500"))
				)
			Hexagon(.flat, body: 200)
				.inset(by: 2)
				.fill(Color("red.sys.500"))
				.frame(height: 16)
				.overlay(
					Hexagon(.flat, body: 200)
						.inset(by: 2)
						.strokeBorder(Color("red.sys.700"))
				)
		}
	}
	
	var bar2: some View {
		ZStack {
			Hexagon(.flat, body: .infinity)
				.fill(Color("grey.sys.300"))
				.frame(height: 16)
				.overlay(
					Hexagon(.flat, body: .infinity)
						.inset(by: -2)
						.strokeBorder(Color("grey.sys.500"))
				)
			Hexagon(.flat, body: 220)
				.inset(by: 2)
				.fill(Color("red.sys.600"))
				.frame(height: 16)
				.overlay(
					Hexagon(.flat, body: 220)
						.inset(by: 5)
						.fill(Color("red.sys.700"))
				)
		}
	}
	
	var bar3: some View {
		ZStack {
			HexBar(bar: HexBar.UI(inset: 0, lum: .light),
			       border: HexBar.UI(inset: -2, lum: .medium))
			
				.allStyle(.grey)
			HexBar(
				length: 180,
				bar: HexBar.UI(inset: 2, lum: .normal),
				border: HexBar.UI(inset: 0, lum: .dark)
			)
			.allStyle(.blue)
		} //: ZStack
		.allStyle(20)
	}
	
	var bar4: some View {
		ZStack {
			HexBar(bar: HexBar.UI(inset: 0, lum: .light),
			       border: HexBar.UI(inset: -2, lum: .medium))
			
				.allStyle(.grey)
			HexBar(
				length: 260,
				bar: HexBar.UI(inset: 2, lum: .normal),
				border: HexBar.UI(inset: 4, lum: .dark)
			)
			.allStyle(.green)
		} //: ZStack
	}

	var bar5: some View {
		ZStack {
			HexBar(bar: HexBar.UI(inset: 0, lum: .light),
			       border: HexBar.UI(inset: -4, lum: .normal))
			
				.allStyle(.grey)
			HexBar(
				length: 160,
				bar: HexBar.UI(inset: 0, lum: .dark),
				border: HexBar.UI(inset: -2, lum: .medium)
			)
			.allStyle(.purple)
		} //: ZStack
	}
	
	var bar6: some View {
		ZStack(alignment: .leading) {
			HexGradientBar(
				bar: HexGradientBar.UI(inset: 0, lums: [.normal, .extraLight, .normal]),
				border: HexGradientBar.UI(inset: -4, lums: [.light, .semiDark, .light])
			)
				.allStyle(.grey)
			HexGradientBar(
				bar: HexGradientBar.UI(inset: 0, lums: [.normal, .medium, .normal]),
				border: HexGradientBar.UI(inset: -2, lums: [.semiDark, .light, .semiDark])
			)
				.frame(width: 90)
				.allStyle(.orange)
		} //: ZStack
	}
	
	var bar7: some View {
		ZStack(alignment: .leading) {
			HexGradientBar(
				bar: HexGradientBar.UI(inset: 0, lums: [.extraLight, .light], start: .top, stop: .bottom),
				border: HexGradientBar.UI(inset: -4, lums: [.normal, .light ], start: .top, stop: .bottom)
			)
				.allStyle(.grey)
			HexGradientBar(
				bar: HexGradientBar.UI(inset: 0, lums: [.medium, .normal], start: .top, stop: .bottom),
				border: HexGradientBar.UI(inset: 0, lums: [.semiDark, .medium], start: .top, stop: .bottom)
			)
				.frame(width: 120)
				.allStyle(.yellow)
		} //: ZStack
	}
	
	var bar8: some View {
		ZStack(alignment: .leading) {
			HexGradientBar(
				bar: HexGradientBar.UI(inset: -3, lums: [.extraLight, .normal], start: .top, stop: .bottom),
				border: HexGradientBar.UI(inset: -4, lums: [.light, .medium], start: .top, stop: .bottom)
			)
				.allStyle(.grey)
			HexGradientBar(
				bar: HexGradientBar.UI(inset: 0, lums: [.semiDark, .light], start: .top, stop: .bottom),
				border: HexGradientBar.UI(inset: -1, lums: [.dark, .extraLight], start: .top, stop: .bottom)
			)
				.frame(width: 280)
				.allStyle(.green)
		} //: ZStack
	}
	
	var bar9: some View {
		ZStack(alignment: .leading) {
			HexGradientBar(
				bar: HexGradientBar.UI(inset: 0, lums: [.light, .extraLight, .light]),
				border: HexGradientBar.UI(inset: -6, lums: [.normal, .light, .normal])
			)
				.allStyle(.grey)
			HexGradientBar(
				bar: HexGradientBar.UI(inset: 2, lums: [.normal, .medium, .normal]),
				border: HexGradientBar.UI(inset: -3, lums: [.dark, .light, .dark])
			)
				.frame(width: 190)
				.offset(x: 93)
				.allStyle(.blue)
			HexGradientBar(
				bar: HexGradientBar.UI(inset: 2, lums: [.normal, .medium, .normal]),
				border: HexGradientBar.UI(inset: -3, lums: [.dark, .light, .dark])
			)
				.frame(width: 90)
				.allStyle(.green)
		} //: ZStack
	}
}

struct HexBar: View {
	@Environment(\.allHue) var hue
	@Environment(\.allSize) var size
	
	var inset: CGFloat = 0
	var length: CGFloat = .infinity
	
	struct UI {
		var inset: CGFloat = 0
		var lum: ColorLuminance
	}
	
	var bar = UI(lum: .extraLight)
	var border = UI(lum: .medium)
	
	var body: some View {
		ZStack {
			Hexagon(.flat, body: length)
				.inset(by: bar.inset)
				.fill(ColorPreset(hue: hue, lum: bar.lum).getColor())
				.frame(height: size)
				.overlay(
					Hexagon(.flat, body: length)
						.inset(by: border.inset)
						.strokeBorder(ColorPreset(hue: hue, lum: border.lum).getColor())
				)
		}
	}
}

struct HexGradientBar: View {
	@Environment(\.allHue) var hue
	@Environment(\.allSize) var size
	
	var inset: CGFloat = 0
	var length: CGFloat = .infinity
	
	struct UI {
		var inset: CGFloat = 0
		var lums: [ColorLuminance] = [.light, .nearWhite, .light]
		var start: UnitPoint = .leading
		var stop: UnitPoint = .trailing
	}
	
	var bar = UI(lums: [])
	var border = UI(lums: [])
		
	var body: some View {
		let barFill = LinearGradient(gradient:
			Gradient(colors: bar.lums.map { ColorPreset(hue: hue, lum: $0).getColor() }),
											  startPoint: bar.start,
											  endPoint: bar.stop)
		
		let borderFill = LinearGradient(gradient:
			Gradient(colors: border.lums.map { ColorPreset(hue: hue, lum: $0).getColor() }),
											  startPoint: border.start,
											  endPoint: border.stop)

		Hexagon(.flat, body: length)
			.inset(by: bar.inset)
			.fill(barFill)
			.frame(height: size)
			.overlay(
				Hexagon(.flat, body: length)
					.inset(by: border.inset)
					.strokeBorder(borderFill)
			)

	}
}
