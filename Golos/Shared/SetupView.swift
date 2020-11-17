//
//  SetupView.swift
//  Golos
//
//  Created by Felix Akira Green on 11/14/20.
//

import SwiftUI

struct SetupView: View {
    var body: some View {
		VStack(spacing: 8.0) {
			Text("We will do all the setup here...")
			TimeBlockerSetupView()
		}
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
