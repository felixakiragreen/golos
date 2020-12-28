//
//  TimeBlockerView.swift
//  Golos
//
//  Created by Felix Akira Green on 11/14/20.
//

import SwiftUI

struct TimeBlockerView: View {
	let testCategories: [Category]
	let testBlocks: [Block]
	
	let capsules = 0..<24
	
	init() {
		testCategories = [
			Category(name: "Recover", color: .green),
			Category(name: "Craft", color: .blue),
			Category(name: "Fight", color: .red),
		]
		testBlocks = [
			Block(name: "Sleep", category: testCategories[0], startHour: 0, startMinute: 0, endHour: 8, endMinute: 59),
			Block(name: "CK3", category: testCategories[2], startHour: 9, startMinute: 0, endHour: 11, endMinute: 59),
			Block(name: "Work", category: testCategories[1], startHour: 12, startMinute: 0, endHour: 12, endMinute: 29),
			Block(name: "Chores", category: testCategories[2], startHour: 12, startMinute: 30, endHour: 13, endMinute: 59),
		]
	}
	
	var body: some View {
		VStack {
			HStack(spacing: 8.0) {
				ForEach(capsules) { idx in
					VStack {
						Text("\(idx)")
					}
				}.frame(maxWidth: .infinity)
			}
			ZStack {
				HStack(spacing: 8.0) {
					ForEach(0..<4) { _ in
						HStack {
							RoundedRectangle(cornerRadius: 8, style: .circular)
								.foregroundColor(Color.gray.opacity(0.2))
						}
					}
				}
				HStack(spacing: 8.0) {
					ForEach(capsules) { _ in
						VStack {
							Capsule(style: .continuous)
								.foregroundColor(Color.gray.opacity(0.2))
								.padding(.vertical, 24.0)
						}
					}
				}
				HStack(spacing: 8.0) {
					ForEach(capsules) { hourIndex in
						let filteredBlocks: [Block] = testBlocks.filter {
							hourIndex >= $0.startHour && hourIndex <= $0.endHour
						}
						
						VStack {
							if filteredBlocks.isEmpty {
								Capsule()
									.foregroundColor(Color.secondary)
							} else {
								GeometryReader { metrics in
									VStack(spacing: 0.0) {
										ForEach(filteredBlocks) { block in
											
											let blockIsBetweener: Bool = hourIndex != block.startHour && hourIndex != block.endHour
											
											let heightPercentage: CGFloat = {
												if blockIsBetweener {
													return CGFloat(60)
												} else if hourIndex != block.endHour {
													return CGFloat(block.endMinute - block.startMinute + 1)
												} else {
													return CGFloat(block.endMinute + 1)
												}
												
											}() / 60 // This divides by minutes in order to convert to a percentage
										
											if blockIsBetweener {
												RoundedRectangle(cornerRadius: 4, style: .circular)
													.padding(.horizontal, -4)
													.foregroundColor(block.category.color.opacity(0.2))
											} else {
												Capsule()
													// .padding(4)
													.foregroundColor(block.category.color)
													.frame(height: metrics.size.height * heightPercentage)
											}
										}
									}
								}
							}
						}.padding(.vertical, 24)
					}
				}
			}
		}
	}
}

struct Block: Identifiable {
	let id = UUID()
	let name: String
	let category: Category
	let startHour: Int
	let startMinute: Int
	let endHour: Int
	let endMinute: Int
}

struct Category: Identifiable {
	let id = UUID()
	let name: String
	let color: Color
	//	 TODO: add subcategories
}

struct TimeBlocker_Previews: PreviewProvider {
	static var previews: some View {
		TimeBlockerView()
	}
}
