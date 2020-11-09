//
//  NowView.swift
//  Golos
//
//  Created by Felix Akira Green on 11/7/20.
//

import SwiftUI

struct Task: Identifiable, Hashable {
	var id = UUID()
	var title: String
	var completed = false
}

class TaskPlanning: ObservableObject {
	@Published var tasks: [Task] = [
		Task(title: "Here’s to the crazy ones\nsdfg\nsdgsdfg"),
		Task(title: "the misfits, the rebels, the troublemakers", completed: true),
		Task(title: "the round pegs in the square holes…"),
		Task(title: "the ones who see things differently — they’re not fond of rules…"),
		Task(title: "You can quote them, disagree with them, glorify or vilify them"),
		Task(title: "but the only thing you can’t do is ignore them because they change things…"),
		Task(title: "they push the human race forward", completed: true),
		Task(title: "and while some may see them as the crazy ones"),
		Task(title: "we see genius", completed: true),
		Task(title: "because the ones who are crazy enough to think that they can change the world"),
		Task(title: "are the ones who do.")
	]
}

struct NowView: View {
	@State var selectedDate = Date()

//	@ObservedObject
//	var planning = TaskPlanning()
	
	@StateObject var planning = TaskPlanning()
	
	// TODO: later change
	@State var listSelection = Set<Task>()
//	@State var selection: Task?

	var body: some View {
		VStack {
			HStack {
				Spacer()
				DisplaySelectedDateView(selectedDate: selectedDate)
				Spacer()
			}
//			List(selection: $listSelection) {
//				VStack(spacing: 16.0) {
//					HStack {
//						Image(systemName: "gamecontroller")
//						Text("My gameplan for the day...")
//							.font(.headline)
//					}
//
//					VStack(spacing: 4.0) {
//						ForEach(plannedTasks.indices, id: \.self) { index in
//							TaskView(task: $plannedTasks[index])
//								.tag(plannedTasks[index])
//						}
//					}
//				}
//			}
			List(planning.tasks, id: \.self, selection: $listSelection) { task in
				TaskView(task: task)
					.tag(task)
			}
			.padding(.all)
		}
	}
}

struct TaskView: View {
//	@State
//	@Binding
	
	
	@ObservedObject var task: Task
	
//	var planning = TaskPlanning()
//	@Binding var selection: Set<Task>
	@State var isEditing = false
	
//	var taskIndex: Int {
//		planning.tasks.firstIndex(where: { $0.id == task.id })!
//	}

	//	should IsEditing turn it into a form?
	
	var body: some View {
		HStack(alignment: .firstTextBaseline, spacing: 8) {
			Button(action: {
				withAnimation {
//					task.completed.toggle()
//					self.planning[self.taskIndex].completed.toggle()
				}
			}) {
				SquareBrick(percent: task.completed ? 100 : 0, fillDirection: .toTop)
					.frame(width: 10, height: 10)
			}
			.buttonStyle(PlainButtonStyle())
			
//			if isEditing {
//				TextEditor(text: $task.title)
//			} else {
				Text($task.title)
					.strikethrough(task.completed)
					.foregroundColor(task.completed ? .secondary : .primary)
//			}
			
			Spacer()
			
			Button(action: {
				isEditing.toggle()
			}) {
				Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil.circle")
			}
//			.buttonStyle(BorderlessButtonStyle())
		}
//		.background(selection.contains(task) ? Color.red : Color.clear)
//		.onTapGesture {
//			print("\(selection)")
//			if selection.contains(task) {
//				selection.remove(task)
//			} else {
//				selection.insert(task)
//			}
//			if !isEditing {
//				isEditing.toggle()
//			}
//		}
		
	}
}

struct NowView_Previews: PreviewProvider {
	static var previews: some View {
		NowView()
	}
}
