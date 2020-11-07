//
//  Extensions.swift
//  Golos
//
//  Created by Felix Akira Green on 11/6/20.
//  Copied from https://www.raywenderlich.com/7589178-how-to-create-a-neumorphic-design-with-swiftui#toc-anchor-012

import SwiftUI

extension View {
  // 1
  func inverseMask<Mask>(_ mask: Mask) -> some View where Mask: View {
	 // 2
	 self.mask(mask
		// 3
		.foregroundColor(.black)
		// 4
		.background(Color.white)
		// 5
		.compositingGroup()
		// 6
		.luminanceToAlpha()
	 )
  }
}
