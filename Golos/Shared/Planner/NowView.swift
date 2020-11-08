//
//  NowView.swift
//  Golos
//
//  Created by Felix Akira Green on 11/7/20.
//

import SwiftUI

struct NowView: View {
	@State var selectedDate = Date()

	var body: some View {
		VStack {
			DisplaySelectedDateView(selectedDate: selectedDate)
			Spacer()
		}.frame(
			maxWidth: .infinity,
			maxHeight: .infinity
		)
	}
}

struct NowView_Previews: PreviewProvider {
	static var previews: some View {
		NowView()
	}
}
