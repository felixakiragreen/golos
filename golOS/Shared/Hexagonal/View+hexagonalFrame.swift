//
//  View+hexagonalFrame.swift
//  golOS
//
//  Created by Felix Akira Green on 1/7/21.
//

import SwiftUI

/// Math for drawing hexagonal angles
let α = CGFloat(Double.pi / 3)

enum HexagonalOrientation {
	case pointy, flat
}

extension View {
	func hexagonalFrame(width: CGFloat, orientation: HexagonalOrientation = .pointy) -> some View {
		frame(
			width: width,
			height: orientation == .pointy ? width / sin(α) : width * sin(α),
			alignment: .center
		)
	}

	func hexagonalFrame(height: CGFloat, orientation: HexagonalOrientation = .pointy) -> some View {
		frame(
			width: orientation == .pointy ? height * sin(α) : height / sin(α),
			height: height,
			alignment: .center
		)
	}
}
