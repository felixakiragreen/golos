//
//  TimelineView.swift
//  Golos
//
//  Created by Felix Akira Green on 11/1/20.
//

import SwiftUI

struct TimelineView: View {
	var body: some View {
		HStack {
			Spacer()
			Text("Timeline")
			Spacer()
		}
		.frame(minHeight: 100)
		.background(Color(.systemRed).opacity(0.1))
	}
}

struct TimelineView_Previews: PreviewProvider {
	static var previews: some View {
		TimelineView()
	}
}
