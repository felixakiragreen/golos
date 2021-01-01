//
//  Environment.swift
//  golOS
//
//  Created by Felix Akira Green on 12/30/20.
//

import SwiftUI

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
}
