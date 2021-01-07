//
//  Environment.swift
//  golOS
//
//  Created by Felix Akira Green on 12/30/20.
//

import SwiftUI

/**
TODO:
- consolidate parentHue
- add hexagonal rounding


*/

struct ParentHueEnvironmentKey: EnvironmentKey {
	static var defaultValue: ColorHue = .grey
}

extension EnvironmentValues {
	var parentHue: ColorHue {
		get { self[ParentHueEnvironmentKey.self] }
		set { self[ParentHueEnvironmentKey.self] = newValue }
	}
}

extension View {
	func parentHueStyle(_ hue: ColorHue) -> some View {
		environment(\.parentHue, hue)
	}
	
	func parentHueStyle(hue: ColorHue) -> some View {
		environment(\.parentHue, hue)
	}
}

struct AllHueEnvironmentKey: EnvironmentKey {
	static var defaultValue: ColorHue = .green
}
struct AllSizeEnvironmentKey: EnvironmentKey {
	static var defaultValue: CGFloat = 12
}

extension EnvironmentValues {
	var allHue: ColorHue {
		get { self[AllHueEnvironmentKey.self] }
		set { self[AllHueEnvironmentKey.self] = newValue }
	}
	var allSize: CGFloat {
		get { self[AllSizeEnvironmentKey.self] }
		set { self[AllSizeEnvironmentKey.self] = newValue }
	}
}

extension View {
	func allStyle(_ hue: ColorHue) -> some View {
		environment(\.allHue, hue)
	}
	
	func allStyle(_ size: CGFloat) -> some View {
		environment(\.allSize, size)
	}
}
