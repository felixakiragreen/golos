//
//  ContentView.swift
//  Shared
//
//  Created by Felix Akira Green on 2/12/21.
//

import CoreData
import SwiftUI

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			// .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}

struct ContentView: View {
	// MARK: - PROPS

	@Environment(\.calendar) var calendar
	// @Environment(\.managedObjectContext) private var viewContext

//	@FetchRequest(
//		sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//		animation: .default
//	)
//	private var items: FetchedResults<Item>
	
	@StateObject var solarModel = SolarModel(date: Date())

	// MARK: - BODY

	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .top) {
				SolarView()
					.environment(\.temporalSpec, TemporalSpec(contentSize: geometry.size.height))
					.environment(\.physicalSpec, PhysicalSpec())
					.environment(\.devDebug, false)
					.environmentObject(solarModel)
				VStack {
					Spacer()
					bottomBar
				}
				.ignoresSafeArea()
			}//: ZStack
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
		}
// 		List {
// //			ForEach(items) { item in
// //				Text("Item at \(item.timestamp!, formatter: itemFormatter)")
// //			}
// //			.onDelete(perform: deleteItems)
// 		}
// 		.toolbar {
// 			#if os(iOS)
// 				EditButton()
// 			#endif
//
// 			Button(action: addItem) {
// 				Label("Add Item", systemImage: "plus")
// 			}
// 		}
	}
	
	var bottomBar: some View {
		VisualEffectBlur(
			blurStyle: .systemThinMaterial,
			vibrancyStyle: UIVibrancyEffectStyle.label
		) {
			VStack {
				HStack {
					Button("go back 1 day") {
						let backOne = calendar.date(
							byAdding: .day, value: -1, to: solarModel.focalDate
						)!
						
						solarModel.reinit(date: backOne)
					}
					Text("today: \(debugTime(solarModel.focalDate))")
					Button("go forward 1 day") {
						let backOne = calendar.date(
							byAdding: .day, value: 1, to: solarModel.focalDate
						)!
						
						solarModel.reinit(date: backOne)
					}
				}
			}
		}
		.frame(maxHeight: 100)
	}

	private func addItem() {
		// withAnimation {
		// 	let newItem = Item(context: viewContext)
		// 	newItem.timestamp = Date()
		//
		// 	do {
		// 		try viewContext.save()
		// 	}
		// 	catch {
		// 		// Replace this implementation with code to handle the error appropriately.
		// 		// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		// 		let nsError = error as NSError
		// 		fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		// 	}
		// }
	}

	private func deleteItems(offsets _: IndexSet) {
		// withAnimation {
		// 	offsets.map { items[$0] }.forEach(viewContext.delete)
  //
		// 	do {
		// 		try viewContext.save()
		// 	}
		// 	catch {
		// 		// Replace this implementation with code to handle the error appropriately.
		// 		// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		// 		let nsError = error as NSError
		// 		fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		// 	}
		// }
	}
}
