//
//  Hexagonal.swift
//  golOS
//
//  Created by Felix Akira Green on 12/29/20.
//

import SwiftUI


struct Hexagonal_Previews: PreviewProvider {
	static var previews: some View {
		Hexagonal()
			.preferredColorScheme(.dark)
	}
}

struct Hexagonal: View {
	var body: some View {
		VStack(spacing: 16.0) {
			HStack {
				PointyHexagon()
					.hexagonalFrame(width: 50)
				PointyHexagon()
					.hexagonalFrame(height: 50)
			}
			HStack {
				PointyHexagonalShape()
					.fill(Color("red.500"))
					.hexagonalFrame(width: 100)
				
				ZStack {
					PointyHexagonalShape()
						.fill(Color("red.700"))
						.hexagonalFrame(width: 100)
					
					PointyHexagonalShape()
						.inset(by: 6)
						.strokeBorder(Color("blue.300"), lineWidth: 6, antialiased: true)
						.hexagonalFrame(width: 100)
				}
			}
			HStack {
				FlatHexagonalShape()
					.fill(Color("red.500"))
					.hexagonalFrame(height: 100, orientation: .flat)
				
				ZStack {
					FlatHexagonalShape()
					.fill(Color("red.700"))
					.hexagonalFrame(height: 100, orientation: .flat)
					
					FlatHexagonalShape()
					.inset(by: 6)
					.strokeBorder(Color("blue.300"), lineWidth: 6, antialiased: true)
					.hexagonalFrame(height: 100, orientation: .flat)
				}
			}
			HStack {
				PointyHexagonalShape(body: .infinity)
					.frame(height: 200)
			}
			HStack {
				FlatHexagon()
					.hexagonalFrame(width: 50, orientation: .flat)
				FlatHexagon()
					.hexagonalFrame(height: 50, orientation: .flat)
			}
//			FlatHexagon(length: .infinity)
//				.frame(height: 100)
			FlatHexagonalShape(body: .infinity)
				.frame(height: 100)
		}
	}
}


// MARK: - CONSTRUCTIONS

/// Math for drawing hexagonal angles
let α = CGFloat(Double.pi / 3)

/// Shape ⬢
struct PointyHexagonalShape: InsettableShape {
	let offset: CGPoint = .zero
//	let center: CGFloat /// Midline, on X axis for vertical hexagons
	
	var inset: CGFloat = 0

	var head: Bool = true
	var body: CGFloat? /// Regularly the length of a side, but specificying 0 makes a diamond
	var tail: Bool = true
	var full: Bool = false /// Extend to edge IF tips (head/tail) are turned off
	
	func path(in rect: CGRect) -> Path {
		var p = Path()
		let center = min(rect.size.width, rect.size.height) / 2
		let side = center / sin(α)
		let tip = side / 2

		let length = body == .infinity ? rect.size.height - side : body
		let trunk = length ?? side
		
		/// Calculate top positions
		let topOffset = full ? 0 : tip
		let topTip = head ? tip : topOffset
		let topPoint = head ? 0 : topOffset
		
		/// Calculate bottom positions
		let botOffset = full ? tip : 0
		let botTip = tail ? tip : tip + botOffset
		let botPoint = tail ? tip * 2 : botTip
		
		/// Calculate inset offsets
		let insetW = inset / sin(α)
		let insetX = insetW * sin(α)
		let insetY = insetW * cos(α)
		
		p.addLines([
			/// top
			
			CGPoint(
				x: offset.x + insetX,
				y: offset.y + insetY + topTip
			), /// top left
			CGPoint(
				x: offset.x + center,
				y: offset.y + insetW + topPoint
			), /// top
			CGPoint(
				x: offset.x - insetX + center * 2,
				y: offset.y + insetY + topTip
			), /// top right
			
			/// bottom
			
			CGPoint(
				x: offset.x - insetX + center * 2,
				y: offset.y - insetY + trunk + botTip
			), /// bot right
			CGPoint(
				x: offset.x + center,
				y: offset.y - insetW + trunk + botPoint
			), /// bot
			CGPoint(
				x: offset.x + insetX,
				y: offset.y - insetY + trunk + botTip
			) /// bot left

		])
		
		p.closeSubpath()

		return p
	}

	func inset(by amount: CGFloat) -> some InsettableShape {
		 var hex = self
		 hex.inset += amount
		 return hex
	}
}

/// Shape ⬣
struct FlatHexagonalShape: InsettableShape {
	let offset: CGPoint = .zero
	// let center: CGFloat /// Midline, on X axis for vertical hexagons

	var inset: CGFloat = 0
	
	var head: Bool = true
	var body: CGFloat? /// Regularly the length of a side, but specificying 0 makes a diamond
	var tail: Bool = true
	var full: Bool = false /// Extend to edge IF tips (head/tail) are turned off
	
	func path(in rect: CGRect) -> Path {
		var p = Path()
		
		let center = min(rect.size.width, rect.size.height) / 2
		let side = center / sin(α)
		let tip = side / 2

		let length = body == .infinity ? rect.size.width - side : body
		let trunk = length ?? side
		
		/// Calculate left positions
		let leftOffset = full ? 0 : tip
		let leftTip = head ? tip : leftOffset
		let leftPoint = head ? 0 : leftOffset

		/// Calculate right positions
		let rightOffset = full ? tip : 0
		let rightTip = tail ? tip : tip + rightOffset
		let rightPoint = tail ? tip * 2 : rightTip
		
		/// Calculate inset offsets
		let insetW = inset / sin(α)
		let insetX = insetW * cos(α)
		let insetY = insetW * sin(α)
		
		p.addLines([
			/// left
			CGPoint(
				x: offset.x + insetX + leftTip,
				y: offset.y - insetY + center * 2
			), /// left bot
			CGPoint(
				x: offset.x + insetW + leftPoint,
				y: offset.y + center
			), /// left
			CGPoint(
				x: offset.x + insetX + leftTip,
				y: offset.y + insetY
			), /// left top
			
			/// right
			CGPoint(
				x: offset.x - insetX + trunk + rightTip,
				y: offset.y + insetY
			), /// right top
			CGPoint(
				x: offset.x - insetW + trunk + rightPoint,
				y: offset.y + center
			), /// right
			CGPoint(
				x: offset.x - insetX + trunk + rightTip,
				y: offset.y - insetY + center * 2
			) /// right bot
		])
		
		p.closeSubpath()

		return p
	}
	
	func inset(by amount: CGFloat) -> some InsettableShape {
		 var hex = self
		 hex.inset += amount
		 return hex
	}
}


//struct HexagonalShape: InsettableShape {
//	let offset: CGPoint = .zero
////	let center: CGFloat /// Midline, on X axis for vertical hexagons
//
//	var inset: CGFloat = 0
//
//	var head: Bool = true
//	var body: CGFloat? /// Regularly the length of a side, but specificying 0 makes a diamond
//	var tail: Bool = true
//	var full: Bool = false /// Extend to edge IF tips (head/tail) are turned off
//
//	func path(in rect: CGRect) -> Path {
//		var p = Path()
//		let trunk = body ?? center / sin(α)
//		let tip = center / sin(α) / 2
//
//		/// Calculate top positions
//		let topOffset = full ? 0 : tip
//		let topTip = head ? tip : topOffset
//		let topPoint = head ? 0 : topOffset
//
//		/// Calculate bottom positions
//		let botOffset = full ? tip : 0
//		let botTip = tail ? tip : tip + botOffset
//		let botPoint = tail ? tip * 2 : botTip
//
//		/// Calculate inset offsets
//		let insetW = inset / sin(α)
//		let insetX = insetW * sin(α)
//		let insetY = insetW * cos(α)
//
//		p.addLines([
//			/// top
//
//			CGPoint(
//				x: offset.x + insetX,
//				y: offset.y + insetY + topTip
//			), /// top left
//			CGPoint(
//				x: offset.x + center,
//				y: offset.y + insetW + topPoint
//			), /// top
//			CGPoint(
//				x: offset.x - insetX + center * 2,
//				y: offset.y + insetY + topTip
//			), /// top right
//
//			/// bottom
//
//			CGPoint(
//				x: offset.x - insetX + center * 2,
//				y: offset.y - insetY + trunk + botTip
//			), /// bot right
//			CGPoint(
//				x: offset.x + center,
//				y: offset.y - insetW + trunk + botPoint
//			), /// bot
//			CGPoint(
//				x: offset.x + insetX,
//				y: offset.y - insetY + trunk + botTip
//			) /// bot left
//
//		])
//
//		p.closeSubpath()
//
//		return p
//	}
//
//	func inset(by amount: CGFloat) -> some InsettableShape {
//		 var hex = self
//		 hex.inset += amount
//		 return hex
//	}
//}


enum HexagonalOrientation {
	case pointy, flat
}

extension View {
	func hexagonalFrame(width: CGFloat, orientation: HexagonalOrientation = .pointy) -> some View {
		self
			.frame(
				width: width,
				height: orientation == .pointy ? width / sin(α) : width * sin(α),
				alignment: .center
			)
	}
	func hexagonalFrame(height: CGFloat, orientation: HexagonalOrientation = .pointy) -> some View {
		self
			.frame(
				width: orientation == .pointy ? height * sin(α) : height / sin(α),
				height: height,
				alignment: .center
			)
	}
}



// MARK: - SUBVIEWS

struct PointyHexagon: View {
	var fill = Color("green.felix")
	var length: CGFloat?

	var body: some View {
		GeometryReader { geometry in
			let center = min(geometry.size.width, geometry.size.height) / 2
			let side = center / sin(α)
			let trunk = length == .infinity ? geometry.size.height - side : length
			
			PointyHexagonalShape(
//				center: center,
				body: trunk
			)
			.fill(fill)
		}
	}
}

struct FlatHexagon: View {
	var fill = Color("green.felix")
	var length: CGFloat?

	var body: some View {
		GeometryReader { geometry in
			let center = min(geometry.size.width, geometry.size.height) / 2
			let side = center / sin(α)
			let trunk = length == .infinity ? geometry.size.width - side : length

			FlatHexagonalShape(
				body: trunk
			)
			.fill(fill)
		}
	}
}
