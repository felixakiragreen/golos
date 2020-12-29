//
//  ContentView.swift
//  Shared
//
//  Created by Felix Akira Green on 12/28/20.
//

import SwiftUI

struct ContentView: View {
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
					HStack {
						Spacer()
						Text("survive")
						Spacer()
					}
					.frame(minHeight: 100)
					.background(Color("red.sys.300"))
					
					HStack {
						Spacer()
						Text("strive")
						Spacer()
					}
					.frame(minHeight: 100)
					.background(Color("green.sys.300"))
					
					HStack {
						Spacer()
						Text("thrive")
						Spacer()
					}
					.frame(minHeight: 100)
					.background(Color("blue.sys.300"))
				}
			}
		}
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
