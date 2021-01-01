//
//  DetailView.swift
//  golOS
//
//  Created by Felix Akira Green on 12/29/20.
//

import SwiftUI

// MARK: - PREVIEW

struct DetailView_Previews: PreviewProvider {
	static var previews: some View {
		DetailView(editData: .constant(TemporalAnnotation.EditData()))
	}
}

struct DetailView: View {
	// MARK: - PROPS

	@Binding var editData: TemporalAnnotation.EditData
	
	// MARK: - BODY

	var body: some View {
		let timeRangeComponents = Calendar.current.dateComponents(
			[.hour, .minute], from: editData.start, to: editData.end
		)
		
		ZStack {
//			Color.red.edgesIgnoringSafeArea(.all)
			
			List {
				Section(header: Text("what")) {
					TextField("Title", text: $editData.group)
//					AutoFocusTextField("Title", text: $editData.group)
//					HStack {
//						Text("~group")
//						Text("~subtype")
//					}
				}
				
				Section(header: Text("when")) {
					HStack {
						DatePicker("start",
						           selection: $editData.start,
						           in: ...editData.end,
						           displayedComponents: [.hourAndMinute])
						DatePicker("end",
						           selection: $editData.end,
						           in: editData.start...,
						           displayedComponents: [.hourAndMinute])
					}
					Text("\(timeRangeComponents.hour ?? 0)h \(timeRangeComponents.minute ?? 0)m")
//					Text("duration \(editData.end - editData.start)")
				}
				
				Section(header: Text("how")) {
					VStack {
						Text("notes")
						Text("tags")
						Text("metrics")
					}
				}
			}
			.background(Color.red)
			.listStyle(InsetGroupedListStyle())
		}
	}
}

/*

TODO's

- make first Textfield autofocus
- make the datepicker use 5 minute intervals
- saving

*/
