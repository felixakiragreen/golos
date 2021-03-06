//
//  ScrollViewOffset.swift
//  golOS
//
//  Created by Felix Akira Green on 2/14/21.
//

// Adapted from: https://github.com/zntfdr/FiveStarsCodeSamples/blob/main/ScrollView-Offset/ScrollViewOffset.swift

import SwiftUI


struct ScrollViewOffset_Previews: PreviewProvider {
	static var previews: some View {
		ScrollViewOffsetView()
	}
}

struct ScrollViewOffsetView: View {
	var body: some View {
		ScrollViewOffset { offset in
			print("New ScrollView offset: \(offset)")
		} content: {
			LazyVStack {
				ForEach(0 ..< 100) { index in
					Text("\(index)")
				}
			}
		}
	}
}

struct ScrollViewOffset<Content: View>: View {
	let onOffsetChange: (CGFloat) -> Void
	let content: () -> Content
	
	init(
		onOffsetChange: @escaping (CGFloat) -> Void,
		@ViewBuilder content: @escaping () -> Content
	) {
		self.onOffsetChange = onOffsetChange
		self.content = content
	}
	
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(spacing: 0) {
				offsetReader
				content()
			}
		}
		.coordinateSpace(name: "frameLayer")
		.onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChange)
	}
	
	var offsetReader: some View {
		GeometryReader { proxy in
			Color.clear
				.preference(
					key: OffsetPreferenceKey.self,
					value: proxy.frame(in: .named("frameLayer")).minY
				)
		}
		.frame(height: 0)
	}
}

private struct OffsetPreferenceKey: PreferenceKey {
	static var defaultValue: CGFloat = .zero
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
