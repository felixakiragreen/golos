//
//  DailyActivityBricksView.swift
//  Golos
//
//  Created by Felix Akira Green on 11/5/20.
//

import SwiftUI

struct DailyActivityBricksView: View {
    var body: some View {
		
		VStack(spacing: 8) {
			HStack(spacing: 8) {
				HabitBrick()
				Spacer()
				HabitBrick(level: .developing)
				Spacer()
				HabitBrick(completion: .completed)
				Spacer()
				HabitBrick(completion: .completed, level: .developing)
//				Image(systemName: "triangle.fill")
//				Image(systemName: "circle.fill")
			}
			Divider()
			HStack(spacing: 8) {
				Image(systemName: "arrow.clockwise")
				Spacer()
				Image(systemName: "sunrise")
				Spacer()
				Image(systemName: "sun.max")
				Spacer()
				Image(systemName: "sunset")
			}
		}.font(.title)
    }
}

//	TODO: rename, refactor, reorgnize
enum HabitCompletion {
	case unstarted
	case completed
}

//	TODO: rename, refactor, reorgnize
enum HabitLevel {
	case habitual
	case developing
}

struct HabitBrick: View {
	var completion: HabitCompletion = .unstarted
	var level: HabitLevel = .habitual
		
	var body: some View {
		let iconName: String = getIconName(level: level, completion: completion)
		
		Image(systemName: iconName).foregroundColor(.green)
	}
	
	func getIconName(level: HabitLevel, completion: HabitCompletion) -> String {
		switch (level, completion) {
			case (.habitual, .completed):
				return "square.fill"
			case (.habitual, .unstarted):
				return "square"
			case (.developing, .completed):
				return "triangle.fill"
			case (.developing, .unstarted):
				return "triangle"
		}
	}
}

struct DailyActivityBricksView_Previews: PreviewProvider {
    static var previews: some View {
        DailyActivityBricksView()
    }
}
