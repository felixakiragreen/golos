//
//  WarRoomView.swift
//  Golos
//
//  Created by Felix Akira Green on 11/1/20.
//

import SwiftUI

struct WarRoomView: View {
    var body: some View {
		
		VStack {
			VStack() {
				Spacer()
				HStack {
					Text("Past")
					Text("Present")
					Text("Future")
					SquareBrick()
				}
				Spacer()
//				.frame(
//					maxWidth: .infinity,
//					maxHeight: .infinity
//				)
				TimelineView()
				Spacer()
				HStack {
					Text("Objectives")
					Text("Chracter")
					Text("Metrics")
				}
				Spacer()
//				.frame(
//					maxWidth: .infinity,
//					maxHeight: .infinity
//				)
			}
			.frame(
				maxWidth: .infinity,
				maxHeight: .infinity
			)
		}
		.navigationTitle("War Room")
		.frame(
			minWidth: 640,
			idealWidth: 1200,
			maxWidth: .infinity,
			minHeight: 480,
			idealHeight: 800,
			maxHeight: .infinity
//			alignment: .leading
		)
    }
}

struct WarRoomView_Previews: PreviewProvider {
    static var previews: some View {
        WarRoomView()
    }
}
