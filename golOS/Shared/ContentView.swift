//
//  ContentView.swift
//  Shared
//
//  Created by Felix Akira Green on 12/28/20.
//

import SwiftUI

struct ContentView: View {
	@State private var isPresented = false

	var body: some View {
		ZStack {
			Color("grey.sys.100").edgesIgnoringSafeArea(.all)
			VStack {
				HStack {
					Text("Hello, world!")
						.padding()
				}
				Spacer()
				VStack(spacing: 16) {
					HStack(alignment: .firstTextBaseline) {
						Spacer()
						Text("critical")
							.foregroundColor(Color("red.sys.900"))
							.font(Font.system(.title2, design: .rounded))
							.bold()
						Text("survive")
							.foregroundColor(Color("red.sys.700"))
						Spacer()
					}
					.frame(minHeight: 100)
					.background(Color("red.sys.300"))

					HStack(alignment: .firstTextBaseline) {
						Spacer()
						Text("productive")
							.foregroundColor(Color("green.sys.900"))
							.font(Font.system(.title2, design: .rounded))
							.bold()
						Text("strive")
							.foregroundColor(Color("green.sys.700"))
						Spacer()
					}
					.frame(minHeight: 100)
					.background(Color("green.sys.300"))

					HStack(alignment: .firstTextBaseline) {
						Spacer()
						Text("non-productive")
							.foregroundColor(Color("blue.sys.900"))
							.font(Font.system(.title2, design: .rounded))
							.bold()
						Text("thrive")
							.foregroundColor(Color("blue.sys.700"))
						Spacer()
					}
					.frame(minHeight: 100)
					.background(Color("blue.sys.300"))
				}
			}
		}
		.navigationTitle("Daily")
//		.sheet(isPresented: $isPresented) {
//			NavigationView {
//				EditView(scrumData: $newScrumData)
//					.navigationBarItems(leading: Button("Dismiss") {
//						isPresented = false
//					}, trailing: Button("Add") {
//						let newScrum = DailyScrum(title: newScrumData.title, attendees: newScrumData.attendees,
//						                          lengthInMinutes: Int(newScrumData.lengthInMinutes), color: newScrumData.color)
//						scrums.append(newScrum)
//						isPresented = false
//					})
//			}
//		}
//		.frame(minWidth: .infinity, minHeight: .infinity)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			ContentView()
		}
		.preferredColorScheme(.dark)
	}
}
