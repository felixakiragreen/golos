//
//  RoundedHexagon.swift
//  golOS
//
//  Created by Felix Akira Green on 1/6/21.
//

import SwiftUI

// MARK: - PREVIEW

struct RoundedHexagonView_Previews: PreviewProvider {
	static var previews: some View {
		RoundedHexagonView()
			.preferredColorScheme(.dark)
	}
}

struct RoundedHexagonView: View {
	// MARK: - PROPS

	// MARK: - BODY

	var body: some View {
		let s: CGFloat = 100
		let p: CGFloat = 20

		VStack(spacing: p) {
//			HStack(spacing: p) {
//				RoundedPointyHexagon(cornerRadius: 0)
//					.hexagonalFrame(width: s)
//					.foregroundColor(Color("red.400"))
//				RoundedPointyHexagon(cornerRadius: 10)
//					.hexagonalFrame(width: s)
//					.foregroundColor(Color("orange.400"))
//				RoundedPointyHexagon(cornerRadius: 20)
//					.hexagonalFrame(width: s)
//					.foregroundColor(Color("yellow.400"))
//			}
			HStack(spacing: p) {
//				RoundedPointyHexagon(cornerRadius: 30)
//					.hexagonalFrame(width: s)
//					.foregroundColor(Color("green.400"))
//				RoundedPointyHexagon(cornerRadius: 40)
//					.hexagonalFrame(width: s)
//					.foregroundColor(Color("blue.400"))
				RoundedInsettablePointyHexagon(cornerRadius: 6, inset: 12)
					.hexagonalFrame(width: s)
					.foregroundColor(Color("blue.400"))
				RoundedInsettablePointyHexagon(cornerRadius: 6, inset: 12, regular: false)
					.frame(width: s, height: s*2)
					.foregroundColor(Color("blue.500"))
			}
			RoundedInsettablePointyHexagon(cornerRadius: 6, inset: 6, regular: false)
				.frame(width: s*3, height: s*2)
				.foregroundColor(Color("blue.600"))
//			HStack {
//				RoundedPointyHexagon(cornerRadius: 50)
//					.hexagonalFrame(width: s)
//					.foregroundColor(Color("purple.400"))
//				ManualRoundedRectangle(cornerRadius: -50)
//					.frame(width: s, height: s)
//			}
//			RoundedPointyHexagon(cornerRadius: -80)
//				.hexagonalFrame(width: s)
//				.foregroundColor(Color("purple.400"))
//			RoundedFlatHexagon(cornerRadius: 0)
//				.hexagonalFrame(height: s, orientation: .flat)
//				.foregroundColor(Color("purple.400"))
		}
	}
}

// MARK: - Rounded ⬢

/**
TODO:

- flat
*/
struct RoundedPointyHexagon: Shape {
	let cornerRadius: CGFloat

	func path(in rect: CGRect) -> Path {
		let half = min(rect.size.width, rect.size.height) / 2
		let side = half / sin(α)
		let tip = side / 2
		
		/// corners 1—6 (topLeading, top, topTrailing, bottomTrailing, bottom, bottomLeading, )
		
		let c1 = CGPoint(x: 0, y: tip)
		let c2 = CGPoint(x: half, y: 0)
		let c3 = CGPoint(x: half * 2, y: tip)
		
		let c4 = CGPoint(x: half * 2, y: tip + side)
		let c5 = CGPoint(x: half, y: side * 2)
		let c6 = CGPoint(x: 0, y: tip + side)
		
		/// calculate cornerRadius
		let adjustedRadius = cornerRadius * 1.162
		let r = min(adjustedRadius, tip)
		
		/// In a 30,60,90 right angle triangle
		/// the long side (hypotenuse) is `r`
		/// the medium side (b) is `rB`, and the short side (a) is `rA`
		let rA = r * cos(α)
		let rB = r * sin(α)
		
		let c12 = CGPoint(x: c1.x + rB, y: c1.y - rA)
		let c16 = CGPoint(x: c1.x, y: c1.y + r)
		
		let c21 = CGPoint(x: c2.x - rB, y: c2.y + rA)
		let c23 = CGPoint(x: c2.x + rB, y: c2.y + rA)
		
		let c32 = CGPoint(x: c3.x - rB, y: c3.y - rA)
		let c34 = CGPoint(x: c3.x, y: c3.y + r)
		
		let c43 = CGPoint(x: c4.x, y: c4.y - r)
		let c45 = CGPoint(x: c4.x - rB, y: c4.y + rA)
		
		let c54 = CGPoint(x: c5.x + rB, y: c5.y - rA)
		let c56 = CGPoint(x: c5.x - rB, y: c5.y - rA)
		
		let c65 = CGPoint(x: c6.x + rB, y: c6.y + rA)
		let c61 = CGPoint(x: c6.x, y: c6.y - r)

//		return Path { path in
//			/// .topLeading
//			path.move(to: c1)
//
//			/// .top
//			path.addLine(to: c2)
//
//			/// .topTrailing
//			path.addLine(to: c3)
//
//			/// .bottomTrailing
//			path.addLine(to: c4)
//
//			/// .bottom
//			path.addLine(to: c5)
//
//			/// .bottomLeading
//			path.addLine(to: c6)
//		}
		
//		return Path { path in
//			/// .topLeading
//			path.move(to: c16)
//			path.addQuadCurve(to: c12, control: c1)
//
//			/// .top
//			path.addLine(to: c2)
//
//			/// .topTrailing
//			path.addLine(to: c3)
//
//			/// .bottomTrailing
//			path.addLine(to: c4)
//
//			/// .bottom
//			path.addLine(to: c5)
//
//			/// .bottomLeading
//			path.addLine(to: c6)
//		}
		
		return Path { path in
			/// .topLeading
			path.move(to: c16)
			path.addQuadCurve(to: c12, control: c1)

			/// .top
			path.addLine(to: c21)
			path.addQuadCurve(to: c23, control: c2)

			/// .topTrailing
			path.addLine(to: c32)
			path.addQuadCurve(to: c34, control: c3)

			/// .bottomTrailing
			path.addLine(to: c43)
			path.addQuadCurve(to: c45, control: c4)

			/// .bottom
			path.addLine(to: c54)
			path.addQuadCurve(to: c56, control: c5)

			/// .bottomLeading
			path.addLine(to: c65)
			path.addQuadCurve(to: c61, control: c6)
		}
	}
}

struct RoundedInsettableRegularPointyHexagon: InsettableShape {
	let cornerRadius: CGFloat
	var inset: CGFloat = 0

	func path(in rect: CGRect) -> Path {
		let half = min(rect.size.width, rect.size.height) / 2
		let side = half / sin(α)
		let tip = side / 2
		
		/// inset
		let i = inset / sin(α)
		/// In a 30,60,90 right angle triangle
		/// the long side (hypotenuse) is `i`
		/// the medium side (b) is `iX`, and the short side (a) is `iY`
		let iX = inset // aka: i * sin(α)
		let iY = i * cos(α)
		
		/// corners 1—6
		let c1 = CGPoint(x: iX, y: tip + iY) /// topLeading
		let c2 = CGPoint(x: half, y: i) /// top
		let c3 = CGPoint(x: half * 2 - iX, y: tip + iY) /// topTrailing
		
		let c4 = CGPoint(x: half * 2 - iX, y: tip + side - iY) /// bottomTraling
		let c5 = CGPoint(x: half, y: side * 2 - i) /// bottom
		let c6 = CGPoint(x: iX, y: tip + side - iY) /// bottomLeading
		
		/// cornerRadius
		let adjustedRadius = cornerRadius * 1.162 // compensating for "continuous"
		let r = min(adjustedRadius, tip)
		
		/// In a 30,60,90 right angle triangle
		/// the long side (hypotenuse) is `r`
		/// the medium side (b) is `rX`, and the short side (a) is `rY`
		let rX = r * sin(α)
		let rY = r * cos(α)
		
		
		let c12 = CGPoint(x: c1.x + rX, y: c1.y - rY)
		let c16 = CGPoint(x: c1.x, y: c1.y + r)
		
		let c21 = CGPoint(x: c2.x - rX, y: c2.y + rY)
		let c23 = CGPoint(x: c2.x + rX, y: c2.y + rY)
		
		let c32 = CGPoint(x: c3.x - rX, y: c3.y - rY)
		let c34 = CGPoint(x: c3.x, y: c3.y + r)
		
		let c43 = CGPoint(x: c4.x, y: c4.y - r)
		let c45 = CGPoint(x: c4.x - rX, y: c4.y + rY)
		
		let c54 = CGPoint(x: c5.x + rX, y: c5.y - rY)
		let c56 = CGPoint(x: c5.x - rX, y: c5.y - rY)
		
		let c65 = CGPoint(x: c6.x + rX, y: c6.y + rY)
		let c61 = CGPoint(x: c6.x, y: c6.y - r)
		
		return Path { path in
			/// .topLeading
			path.move(to: c16)
			path.addQuadCurve(to: c12, control: c1)

			/// .top
			path.addLine(to: c21)
			path.addQuadCurve(to: c23, control: c2)

			/// .topTrailing
			path.addLine(to: c32)
			path.addQuadCurve(to: c34, control: c3)

			/// .bottomTrailing
			path.addLine(to: c43)
			path.addQuadCurve(to: c45, control: c4)

			/// .bottom
			path.addLine(to: c54)
			path.addQuadCurve(to: c56, control: c5)

			/// .bottomLeading
			path.addLine(to: c65)
			path.addQuadCurve(to: c61, control: c6)
		}
	}
	
	func inset(by amount: CGFloat) -> some InsettableShape {
		var hex = self
		hex.inset += amount
		return hex
	}
}

/**
TODO:
- flat
- prevent overextending of irregular hexagons when width is WAY more than height
- consider making all hexagons "irregular" and you make them "regular" by adding .hexagonalFrame
*/
struct RoundedInsettablePointyHexagon: InsettableShape {
	let cornerRadius: CGFloat
	var inset: CGFloat = 0
	var regular: Bool = true
	
	func inset(by amount: CGFloat) -> some InsettableShape {
		var hex = self
		hex.inset += amount
		return hex
	}

	func path(in rect: CGRect) -> Path {
		/// step 1 → dimensions
		let midX = rect.size.width / 2 /// midpoint X
		let midY = rect.size.height / 2 /// midpoint Y
		let half = min(midX, midY) /// take smaller dimension for fitting a regular hexagon inside
		let side = half / sin(α) /// the length of a side of a regular hexagon (equivalent to the half height)

		/// step 1b → regular / irregular
		var mX: CGFloat { /// where the vertical center is for drawing the points & width (vertical becase it's across X)
			if regular { return half }
			else { return midX }
		}
		var mY: CGFloat { /// where the horizontal center is for drawing the height (horizontal because it's across Y)
			if regular { return side }
			else { return midY }
		}
		var tip: CGFloat { /// how long to make the pointy part
			if regular { return side / 2 }
			else { return midX / sin(α) / 2 }
		}
		
		/// step 2 → inset
		let i = inset / sin(α)
		/// In a 30,60,90 right angle triangle
		/// the long side (hypotenuse) is `i`
		/// the medium side (b) is `iX`, and the short side (a) is `iY`
		let iX = inset // aka: i * sin(α)
		let iY = i * cos(α)
		
		/// step 3 → corners (the six vertices)
		let c1 = CGPoint(x: iX, y: tip + iY) /// topLeading
		let c2 = CGPoint(x: mX, y: i) /// top
		let c3 = CGPoint(x: mX * 2 - iX, y: tip + iY) /// topTrailing
		
		let c4 = CGPoint(x: mX * 2 - iX, y: mY * 2 - tip - iY) /// bottomTraling
		let c5 = CGPoint(x: mX, y: mY * 2 - i) /// bottom
		let c6 = CGPoint(x: iX, y: mY * 2 - tip - iY) /// bottomLeading
		
		/// step 4 → rounding corners
		let adjustedRadius = cornerRadius * 1.162 // compensating for "continuous"
		let r = min(adjustedRadius, tip)
		
		/// > In a 30,60,90 right angle triangle
		/// > the long side (hypotenuse) is `r`
		/// > the medium side (b) is `rX`, and the short side (a) is `rY`
		let rX = r * sin(α)
		let rY = r * cos(α)
		
		/// step 4b → corner vertex offset by corner radius
		/// > `c12` is corner1 (`c1`) transformed by cornerRadius (`rX` & `rY`) towards corner2 (`c2`)
		/// > `c21` is corner2 transformed by cornerRadius towards corner1
		let c12 = CGPoint(x: c1.x + rX, y: c1.y - rY)
		let c16 = CGPoint(x: c1.x, y: c1.y + r)
		
		let c21 = CGPoint(x: c2.x - rX, y: c2.y + rY)
		let c23 = CGPoint(x: c2.x + rX, y: c2.y + rY)
		
		let c32 = CGPoint(x: c3.x - rX, y: c3.y - rY)
		let c34 = CGPoint(x: c3.x, y: c3.y + r)
		
		let c43 = CGPoint(x: c4.x, y: c4.y - r)
		let c45 = CGPoint(x: c4.x - rX, y: c4.y + rY)
		
		let c54 = CGPoint(x: c5.x + rX, y: c5.y - rY)
		let c56 = CGPoint(x: c5.x - rX, y: c5.y - rY)
		
		let c65 = CGPoint(x: c6.x + rX, y: c6.y + rY)
		let c61 = CGPoint(x: c6.x, y: c6.y - r)
		
		return Path { path in
			/// .topLeading
			path.move(to: c16)
			path.addQuadCurve(to: c12, control: c1)

			/// .top
			path.addLine(to: c21)
			path.addQuadCurve(to: c23, control: c2)

			/// .topTrailing
			path.addLine(to: c32)
			path.addQuadCurve(to: c34, control: c3)

			/// .bottomTrailing
			path.addLine(to: c43)
			path.addQuadCurve(to: c45, control: c4)

			/// .bottom
			path.addLine(to: c54)
			path.addQuadCurve(to: c56, control: c5)

			/// .bottomLeading
			path.addLine(to: c65)
			path.addQuadCurve(to: c61, control: c6)
		}
	}
}

// MARK: - Rounded ⬣

//struct RoundedFlatHexagon: Shape {
//	let cornerRadius: CGFloat
//
//	func path(in rect: CGRect) -> Path {
////		let half = min(rect.size.width, rect.size.height) / 2
//
//		return RoundedPointyHexagon(cornerRadius: cornerRadius)
//			.rotation(Angle.init(degrees: 90), anchor: .bottom)
//			.path(in: rect)
////			.path(in: rect)
////			.applying(
//////				CGAffineTransform(scaleX: 2, y: 1)
//////				CGAffineTransform(rotationAngle: CGFloat(Angle.init(degrees: 90).radians))
////				CGAffineTransform().rotated(by: 90)
////			)
//
//	}
//}


/**
 Recreation of RoundedRect(style: .continuous)
 TODO:
 - add rounding of specific corners
 - add specific rounding of specific corners
 */

// MARK: - Rounded Rectangle

struct ManualRoundedRectangle: Shape {
	let cornerRadius: CGFloat

	func path(in rect: CGRect) -> Path {
		/// corners 1—4 (topLeading, topTrailing, bottomTrailing, bottomLeading)
		let c1 = CGPoint.zero
		let c2 = CGPoint(x: rect.width, y: 0)
		let c3 = CGPoint(x: rect.width, y: rect.height)
		let c4 = CGPoint(x: 0, y: rect.height)
		
		/// minimum radius can't be more than half the width... I think
		let halfSize = min(rect.width, rect.height) / 2
		
		let adjustedRadius = cornerRadius * 1.162
		let r = min(adjustedRadius, halfSize)
		
		/// This is my convoluted system
		///
		/// c12 is corner1 transformed by cornerRadius towards corner2
		/// c14 is corner1 transformed by cornerRadius towards corner4
		/// c21 is corner2 transformed by cornerRadius towards corner1
		let c12 = CGPoint(x: c1.x + r, y: c1.y)
		let c14 = CGPoint(x: c1.x, y: c1.y + r)
		let c21 = CGPoint(x: c2.x - r, y: c2.y)
		let c23 = CGPoint(x: c2.x, y: c2.y + r)
		let c32 = CGPoint(x: c3.x, y: c3.y - r)
		let c34 = CGPoint(x: c3.x - r, y: c3.y)
		let c43 = CGPoint(x: c4.x + r, y: c4.y)
		let c41 = CGPoint(x: c4.x, y: c4.y - r)
		
		return Path { path in
			/// .topLeading
			path.move(to: c14)
			path.addQuadCurve(to: c12, control: c1)
			
			/// .topTrailling
			path.addLine(to: c21)
			path.addQuadCurve(to: c23, control: c2)
			
			/// .bottomTrailing
			path.addLine(to: c32)
			path.addQuadCurve(to: c34, control: c3)
			
			/// .bottomLeading
			path.addLine(to: c43)
			path.addQuadCurve(to: c41, control: c4)
		}
	}
}
