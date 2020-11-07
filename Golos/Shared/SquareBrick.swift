//
//  SquareBrick.swift
//  Golos
//
//  Created by Felix Akira Green on 11/6/20.
//

import SwiftUI


// The direction in which the shape fills up
enum ProgressDirection {
	case toTop
	case toBottom
	case toRight
	case toLeft
	case toCenter
	case toBorder
}

struct SquareBrick: View {
	var percent: Double = 100
	var fillDirection: ProgressDirection = .toTop
	
	var body: some View {
		// This makes .toCenter flow in the right direction
		let adjustedPercent = fillDirection == .toCenter ? 100 - percent : percent
		
		GeometryReader { geometry in
			let length: CGFloat = SquareBrick.directionToLength(
				direction: fillDirection,
				size: geometry.size
			)
			
			let cornerRadius: CGFloat = length / 5
			
			let clipLength: CGFloat = SquareBrick.percentageOfLength(
				percent: adjustedPercent,
				length: length
			)
			
			let clipOffset = SquareBrick.computeClipOffset(
				direction: fillDirection,
				size: geometry.size,
				clipLength: clipLength
			)
			
			let clipSize = SquareBrick.computeClipSize(
				direction: fillDirection,
				size: geometry.size,
				clipLength: clipLength
			)
			
			ZStack {
				RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
					.foregroundColor(Color.green.opacity(0.2))
							
				switch fillDirection {
				case .toCenter:
					RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
						.foregroundColor(Color.green)
						.inverseMask(
							SquareBrickClipView(
								geometry: geometry,
								fillDirection: fillDirection,
								cornerRadius: cornerRadius,
								clipLength: clipLength,
								clipOffset: clipOffset,
								clipSize: clipSize
							)
						)
				case .toBorder:
					RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
						.foregroundColor(Color.green)
						.mask(
							SquareBrickClipView(
								geometry: geometry,
								fillDirection: fillDirection,
								cornerRadius: cornerRadius,
								clipLength: clipLength,
								clipOffset: clipOffset,
								clipSize: clipSize
							)
						)
				default:
					RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
						.foregroundColor(Color.green)
						.mask(
							SquareBrickClipView(
								geometry: geometry,
								fillDirection: fillDirection,
								cornerRadius: cornerRadius,
								clipLength: clipLength,
								clipOffset: clipOffset,
								clipSize: clipSize
							)
						)
				}
			}
		}
	}
	
	// Helper function to derive the length from the direction
	static func directionToLength(direction: ProgressDirection, size: CGSize) -> CGFloat {
		switch direction {
		case .toTop, .toBottom:
			return size.width
		case .toLeft, .toRight:
			return size.height
		case .toCenter, .toBorder:
			return max(size.width, size.height)
		}
	}
	
	// Helper function to derive the positioning of the clipped shape
	static func computeClipOffset(direction: ProgressDirection, size: CGSize, clipLength: CGFloat) -> CGPoint {
		switch direction {
		case .toBottom, .toRight:
			return CGPoint(x: 0, y: 0)
		case .toTop:
			return CGPoint(x: 0, y: size.height - clipLength)
		case .toLeft:
			return CGPoint(x: size.width - clipLength, y: 0)
		case .toBorder, .toCenter:
			return CGPoint(
				x: (size.width - clipLength) / 2,
				y: (size.height - clipLength) / 2
			)
		}
	}
	
	// Helper function to derive the dimensions of the clipped shape
	static func computeClipSize(direction: ProgressDirection, size: CGSize, clipLength: CGFloat) -> CGSize {
		switch direction {
			case .toTop, .toBottom:
				return CGSize(width: size.width, height: clipLength)
			case .toLeft, .toRight:
				return CGSize(width: clipLength, height: size.height)
			case .toCenter, .toBorder:
				return CGSize(width: clipLength, height: clipLength)
		}
	}
	
	// Helper function to convert percent values to
	static func percentageOfLength(percent: Double, length: CGFloat) -> CGFloat {
		length / 100 * CGFloat(percent)
	}
}

struct SquareBrickClipView: View {
	let geometry: GeometryProxy
	let fillDirection: ProgressDirection
	let cornerRadius: CGFloat
	let clipLength: CGFloat
	let clipOffset: CGPoint
	let clipSize: CGSize

	var body: some View {
		let clipCornerRadius: CGFloat = clipLength / 5

		switch fillDirection {
		case .toCenter, .toBorder:
			RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
				.clipShape(
					RoundedRectangle(cornerRadius: clipCornerRadius, style: .continuous)
						.offset(clipOffset)
						.size(clipSize)
				)
		default:
			Rectangle()
				.offset(clipOffset)
				.size(clipSize)
		}
	}
}


struct SquareBrick_Previews: PreviewProvider {
	static var previews: some View {
		let length = CGFloat(30)

		SquareBrick(percent: 0)
			.frame(width: length, height: length)
		
		// toTop
		Group {
			SquareBrick(percent: 33)
				.frame(width: length, height: length)
			SquareBrick(percent: 66)
				.frame(width: length, height: length)
		}
		
		// .toBottom
		Group {
			SquareBrick(percent: 33, fillDirection: .toBottom)
				.frame(width: length, height: length)
			SquareBrick(percent: 66, fillDirection: .toBottom)
				.frame(width: length, height: length)
		}

		SquareBrick(percent: 33, fillDirection: .toRight)
			.frame(width: length, height: length)
		SquareBrick(percent: 33, fillDirection: .toLeft)
			.frame(width: length, height: length)
		
		// toCenter
		Group {
			SquareBrick(percent: 33, fillDirection: .toCenter)
				.frame(width: length, height: length)
			SquareBrick(percent: 66, fillDirection: .toCenter)
				.frame(width: length, height: length)
		}
		
		// toBorder
		Group {
			SquareBrick(percent: 33, fillDirection: .toBorder)
				.frame(width: length, height: length)
			SquareBrick(percent: 66, fillDirection: .toBorder)
				.frame(width: length, height: length)
		}
		
		SquareBrick()
			.frame(width: length, height: length)
	}
}
