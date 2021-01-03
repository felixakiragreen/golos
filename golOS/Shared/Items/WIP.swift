//
//  WIP.swift
//  golOS
//
//  Created by Felix Akira Green on 1/2/21.
//

import SwiftUI

struct WIP_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			WIP()
			Group {
				WIP(label: "incomplete")
				WIP(label: "don't do this thing", vertical: true)
				WIP(label: "incomplete")
			}
		}
		.preferredColorScheme(.dark)
	}
}

struct WIP: View {
	var label: String?
	var vertical: Bool = false

	var body: some View {
		if vertical {
			VStack(spacing: 8) {
				Label {
					Text("TODO\(label != nil ? ":" : "")")
						.font(Font.system(.headline, design: .monospaced))
						.foregroundColor(Color("orange.sys.600"))

				} icon: {
					Text("🚧")
						.font(.title)
				}
				if let label = label {
					Text(label)
						.foregroundColor(Color("orange.sys.900"))
						.fixedSize(horizontal: true, vertical: false)
//						.padding(4)
//						.background(Color("orange.sys.100"))
				}
			}
		} else {
			HStack {
				Label {
					Text("TODO\(label != nil ? ":" : "")")
						.font(Font.system(.headline, design: .monospaced))
						.foregroundColor(Color("orange.sys.600"))
					if let label = label {
						Text(label)
							.foregroundColor(Color("orange.sys.900"))
//							.background(Color("orange.sys.100"))
					}
				} icon: {
					Text("🚧")
						.font(.title)
				}
			}
		}
	}
}
