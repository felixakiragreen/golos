//
//  Colors.swift
//  golOS
//
//  Created by Felix Akira Green on 12/29/20.
//

import SwiftUI

enum ColorHue: String, CaseIterable {
	case grey, red, orange, yellow, green, blue, purple
}

extension ColorHue: Identifiable {
	 var id: String { rawValue }
}

enum ColorLuminance: Int, CaseIterable {
	case nearWhite = 100
	case extraLight = 200
	case light = 300
	case normal = 400
	case medium = 500
	case semiDark = 600
	case dark = 700
	case extraDark = 800
	case nearBlack = 900
//	case 1 = 100
//	case 2 = 200
//	case 3 = 300
//	case 4 = 400
//	case 5 = 500
//	case 6 = 600
//	case 7 = 700
//	case 8 = 800
//	case 9 = 900
}

extension ColorLuminance: Identifiable {
	 var id: Int { rawValue }
}

struct ColorPreset: Equatable {
//	var id: String
	var hue: ColorHue
	var lum: ColorLuminance
	var sys: Bool = true /// true → color adapts to darkMode (100 → 900)
//	var fellback: Bool = false
	
	/// Initialization from components
	init(hue: ColorHue, lum: ColorLuminance) {
//		self.id = ColorPreset.toString((hue, luminance))
		self.hue = hue
		self.lum = lum
	}
	
	/// Initialization from just a string → ("grey.100")
//	init(_ from: String) {
//		guard let (primary, luminance) = ColorPreset.stringToColorComponents(from) else {
//			self.id = "incorrect"
//			self.primary = .red
//			self.luminance = .extraLight
//			self.fellback = true
//			return
//		}
//
//		self.id = ColorPreset.toString((primary, luminance))
//		self.primary = primary
//		self.luminance = luminance
//	}
	
	/// Empty initialization
//	init() {
//		self.id = "incorrect"
//		self.primary = .red
//		self.luminance = .extraLight
//		self.fellback = true
//	}

	
	// TODO: Put in extensions if I'm going to use
	/*
	func getLabel() -> some View {
		ColorLabel(color: self) {
			Text(getString())
		}
	}
	
	static func splitColorString(_ from: String) -> (String, String) {
		let parts = from.components(separatedBy: ".")
		return (parts[0], parts[1])
	}
	
	static func stringToColorComponents(_ from: String) -> (ColorPrimary, ColorLuminance)? {
		let (p, l) = ColorPreset.splitColorString(from)
		
		guard let primary = ColorPrimary(rawValue: p) else {
			return nil
		}
		guard let intLuminance = Int(l) else {
			return nil
		}
		guard let luminance = ColorLuminance(rawValue: intLuminance) else {
			return nil
		}
		
		return (primary, luminance)
	}

	
	*/
}

extension ColorPreset {
	
	func getString() -> String {
//		if fellback {
//			return "incorrect"
//		}
		return ColorPreset.toString((hue, lum), sys: sys)
	}
	
	func getColor() -> Color {
//		if fellback {
//			return Color.red
//		}
		return Color(getString())
	}
	
	static func toString(_ components: (ColorHue, ColorLuminance), sys: Bool = true) -> String {
		let (hue, lum) = components
		if sys {
			return "\(hue).sys.\(lum.rawValue)"
		} else {
			return "\(hue).\(lum.rawValue)"
		}
	}
}
