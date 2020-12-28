//
//  TimelineBlock.swift
//  golOS layout
//
//  Created by Felix Akira Green on 12/13/20.
//

import SwiftUI

struct TimelineBlock: View {
	var body: some View {
		Rectangle()
			.frame(width: 100, height: 100, alignment: .center)
			.foregroundColor(Color.orange)
	}
}

struct TimelineBlock_Previews: PreviewProvider {
	static var previews: some View {
		TimelineBlock()
	}
}
