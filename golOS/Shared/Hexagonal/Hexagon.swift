//
//  Hexagon.swift
//  golOS
//
//  Created by Felix Akira Green on 1/7/21.
//

import SwiftUI

// MARK: - PREVIEW

struct HexagonView_Previews: PreviewProvider {
	static var previews: some View {
		HexagonView()
	}
}

struct HexagonView: View {
	// MARK: - BODY

	var body: some View {
		let s: CGFloat = 80
		
		VStack {
			HStack {
				PointyHexagon(regular: true)
					.inset(by: 0)
//					.hexagonalFrame(width: 100)
					.frame(width: s, height: s*2)
					.foregroundColor(Color("blue.400"))
			}
		}
	}
}


// MARK: - Shape ⬢

struct PointyHexagon: InsettableShape {
	var inset: CGFloat = 0
	var regular: Bool = false
	
	func inset(by amount: CGFloat) -> some InsettableShape {
		var hex = self
		hex.inset += amount
		return hex
	}

	func path(in rect: CGRect) -> Path {
		let h = HexagonalConstruction(
			rect: rect,
			inset: inset,
			regular: regular,
			orientation: .pointy
		)
		
		return Path	{ path in
			path.addLines([
				h.c1,
				h.c2,
				h.c3,
				h.c4,
				h.c5,
				h.c6
			])

			path.closeSubpath()
		}
	}
}


struct HexagonalConstruction {
	
	var rect: CGRect
	var inset: CGFloat = 0
	var regular: Bool = false
	var orientation: HexagonalOrientation
	var pointy: Bool { orientation == .pointy }

	
	// MARK: - 1. dimensions

	var midX: CGFloat { rect.size.width / 2 } /// midpoint X
	var midY: CGFloat { rect.size.height / 2 } /// midpoint Y
	var half: CGFloat { min(midX, midY) } /// take smaller dimension for fitting a regular hexagon inside
	var side: CGFloat { half / sin(α) } /// the length of a side of a regular hexagon (equivalent to the half height)
	
	// MARK: - 2. lines
	
	/// center lines, tip, for regular / irregular
	var mX: CGFloat {
		/// where the vertical center is for drawing the points & width (vertical becase it's across X)
		switch (pointy, regular) {
		case (true, true):
			/// pointy + regular
			return half
		case (false, true):
			/// flat + regular
			return side
		default:
			/// pointy,flat + irregular
			return midX
		}
	}
	/// where the horizontal center is for drawing the height (horizontal because it's across Y)
	var mY: CGFloat {
		switch (pointy, regular) {
		case (true, true):
			/// pointy + regular
			return side
		case (false, true):
			/// flat + regular
			return half
		default:
			/// pointy,flat + irregular
			return midY
		}
	}
	/// how long to make the pointy part
	var tip: CGFloat {
		switch (pointy, regular) {
		case (true, false):
			/// pointy + irregular
			return midX / sin(α) / 2
		case (false, false):
			/// flat + irregular
			return midY / sin(α) / 2
		default:
			/// pointy,flat + regular
			return side / 2
		}
	}
//	var tip: CGFloat = 10
	
	// MARK: - 3. inset
	
	/// {Flat is FLIPPED Pointy}
	var i: CGFloat { inset / sin(α) }
	/// In a 30,60,90 right angle triangle
	/// the long side (hypotenuse) is `i`, the medium side is (b) and the short side is (a)
	/// Pointy → b = `iX`, a = `iY`
	/// Flat → b = `iY`, a = `iX`
	var iX: CGFloat { pointy ? inset : i * cos(α) }
	var iY: CGFloat { pointy ? i * cos(α) : inset }
	/// FYI: don't need to calculate sin() since `inset = i * sin(α)`
	
	// MARK: - 4. Corners
	
	/// step 4 → corners (the six vertices) {Flat is FLIPPED Pointy}
	var c1: CGPoint { pointy
		? CGPoint(x: iX, y: tip + iY) /// topLeading
		: CGPoint(x: tip + iX, y: mY * 2 - iY) /// bottomLeading
	}
	var c2: CGPoint { pointy
		? CGPoint(x: mX, y: i) /// top
		: CGPoint(x: i, y: mY) /// leading
	}
	var c3: CGPoint { pointy
		? CGPoint(x: mX * 2 - iX, y: tip + iY) /// topTrailing
		: CGPoint(x: tip + iX, y: iY) /// topLeading
	}
	var c4: CGPoint { pointy
		? CGPoint(x: mX * 2 - iX, y: mY * 2 - tip - iY) /// bottomTrailing
		: CGPoint(x: mX * 2 - tip - iX, y: iY) /// topTrailing
	}
	var c5: CGPoint { pointy
		? CGPoint(x: mX, y: mY * 2 - i) /// bottom
		: CGPoint(x: mX * 2 - i, y: mY) /// trailing
	}
	var c6: CGPoint { pointy
		? CGPoint(x: iX, y: mY * 2 - tip - iY) /// bottomLeading
		: CGPoint(x: mX * 2 - tip - iX, y: mY * 2 - iY) /// bottomTrailing
	}
	
	
}

/**
Wondering if maybe I should have a hexagonal construction
then a Hexagonal + Inset
then a Hexagonal + Rounded
*/
