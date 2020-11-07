//
//  Extensions.swift
//  Golos
//
//  Created by Felix Akira Green on 11/6/20.
//

import SwiftUI

// Copied from https://www.raywenderlich.com/7589178-how-to-create-a-neumorphic-design-with-swiftui#toc-anchor-012
extension View {
	// Define a new inverseMask that mimics mask
	func inverseMask<Mask>(_ mask: Mask) -> some View where Mask: View {
		// Return the current view masked with the input mask and modified.
		self.mask(mask
			// Set the foreground color of the input mask to black.
			.foregroundColor(.black)
			// Ensure the background of the input mask is solid white.
			.background(Color.white)
			// Wrap the input mask in a compositing group.
			.compositingGroup()
			// Converted the luminance to alpha, turning the black foreground transparent and keeping the light background opaque — i.e., an inverse mask!
			.luminanceToAlpha())
	}
}

// Copied from https://www.hackingwithswift.com/articles/178/super-powered-string-interpolation-in-swift-5-0
// But no longer using. May remove later but it's a handy reference.
/*
extension String.StringInterpolation {
	mutating func appendInterpolation(noSeparator value: Int) {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.groupingSeparator = ""

		if let result = formatter.string(from: value as NSNumber) {
			appendLiteral(result)
		}
	}
}
*/
