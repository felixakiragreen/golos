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
			VSplitView() {
				TimelineView()
				HStack {
					Text("Objectives")
					Text("Chracter")
					Text("Metrics")
				}
			}
//			.frame(
//				idealWidth: .infinity,
//				idealHeight: .infinity
//			)
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
