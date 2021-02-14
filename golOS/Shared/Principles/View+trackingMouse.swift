//
//  View+trackingMouse.swift
//  FutureUI
//
//  Created by Felix Akira Green on 1/24/21.
//

// Copied from: https://swiftui-lab.com/a-powerful-combo/

import SwiftUI

#if os(macOS)

extension View {
	func trackingMouse(onMove: @escaping (NSPoint) -> Void) -> some View {
		TrackingAreaView(onMove: onMove) { self }
	}
}

struct TrackingAreaView<Content>: View where Content: View {
	let onMove: (NSPoint) -> Void
	//	let isDown: (Bool) -> Void
	let content: () -> Content
	
	init(onMove: @escaping (NSPoint) -> Void, @ViewBuilder content: @escaping () -> Content) {
		self.onMove = onMove
		self.content = content
	}
	
	var body: some View {
		TrackingAreaRepresentable(onMove: onMove, content: self.content())
	}
}

struct TrackingAreaRepresentable<Content>: NSViewRepresentable where Content: View {
	let onMove: (NSPoint) -> Void
	let content: Content
	
	func makeNSView(context: Context) -> NSHostingView<Content> {
		return TrackingNSHostingView(onMove: self.onMove, rootView: self.content)
	}
	
	func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {}
}

class TrackingNSHostingView<Content>: NSHostingView<Content> where Content: View {
	let onMove: (NSPoint) -> Void
	
	init(onMove: @escaping (NSPoint) -> Void, rootView: Content) {
		self.onMove = onMove
		
		super.init(rootView: rootView)
		
		self.setupTrackingArea()
	}
	
	required init(rootView: Content) {
		fatalError("init(rootView:) has not been implemented")
	}
	
	@available(*, unavailable)
	@objc dynamic required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupTrackingArea() {
		//		let options: NSTrackingArea.Options = [.mouseMoved, .activeAlways, .inVisibleRect]
		let options: NSTrackingArea.Options = [.mouseMoved, .enabledDuringMouseDrag, .activeAlways, .inVisibleRect]
		self.addTrackingArea(NSTrackingArea(rect: .zero, options: options, owner: self, userInfo: nil))
	}
	
	override func mouseMoved(with event: NSEvent) {
		self.onMove(self.convert(event.locationInWindow, from: nil))
	}
}

#endif
