//
//  VisualEffectBlur.swift
//  FutureUI
//
//  Created by Felix Akira Green on 2/5/21.
//

import SwiftUI

/**
TODO:
- [ ] add iOS
*/

// MARK: - macOS

#if os(macOS)

// MARK: - VisualEffectBlur

struct VisualEffectBlur: View {
	var material: NSVisualEffectView.Material
	var blendMode: NSVisualEffectView.BlendingMode
	var state: NSVisualEffectView.State
	
	init(
		material: NSVisualEffectView.Material = .hudWindow,
		blendMode: NSVisualEffectView.BlendingMode = .behindWindow,
		state: NSVisualEffectView.State = .followsWindowActiveState
	) {
		self.material = material
		self.blendMode = blendMode
		self.state = state
	}
	
	var body: some View {
		Representable(material: material, blendMode: blendMode, state: state)
			.accessibility(hidden: true)
	}
}

// MARK: - Representable

extension VisualEffectBlur {
	struct Representable: NSViewRepresentable {
		var material: NSVisualEffectView.Material
		var blendMode: NSVisualEffectView.BlendingMode
		var state: NSVisualEffectView.State
		
		func makeNSView(context: Context) -> NSVisualEffectView {
			context.coordinator.visualEffectView
		}
		
		func updateNSView(_ view: NSVisualEffectView, context: Context) {
			context.coordinator.update(material: material, blendMode: blendMode, state: state)
		}
		
		func makeCoordinator() -> Coordinator {
			Coordinator()
		}
	}
	
	class Coordinator {
		let visualEffectView = NSVisualEffectView()
		
		init() {}
		
		func update(
			material: NSVisualEffectView.Material,
			blendMode: NSVisualEffectView.BlendingMode,
			state: NSVisualEffectView.State
		) {
			visualEffectView.material = material
			visualEffectView.blendingMode = blendMode
			visualEffectView.state = state
		}
	}
}

#elseif os(iOS)

// MARK: - iOS

// MARK: - VisualEffectBlur

struct VisualEffectBlur<Content: View>: View {
	var blurStyle: UIBlurEffect.Style
	var vibrancyStyle: UIVibrancyEffectStyle?
	var content: Content

	init(
		blurStyle: UIBlurEffect.Style = .systemMaterial,
		vibrancyStyle: UIVibrancyEffectStyle? = nil,
		@ViewBuilder content: () -> Content
	) {
		self.blurStyle = blurStyle
		self.vibrancyStyle = vibrancyStyle
		self.content = content()
	}
	
	var body: some View {
		Representable(blurStyle: blurStyle, vibrancyStyle: vibrancyStyle, content: ZStack { content })
			.accessibility(hidden: Content.self == EmptyView.self)
	}
}

// MARK: - Representable

extension VisualEffectBlur {
	struct Representable<Content: View>: UIViewRepresentable {
		var blurStyle: UIBlurEffect.Style
		var vibrancyStyle: UIVibrancyEffectStyle?
		var content: Content
		
		func makeUIView(context: Context) -> UIVisualEffectView {
			context.coordinator.blurView
		}
		
		func updateUIView(_ view: UIVisualEffectView, context: Context) {
			context.coordinator.update(content: content, blurStyle: blurStyle, vibrancyStyle: vibrancyStyle)
		}
		
		func makeCoordinator() -> Coordinator {
			Coordinator(content: content)
		}
	}
}

// MARK: - Coordinator

extension VisualEffectBlur.Representable {
	class Coordinator {
		let blurView = UIVisualEffectView()
		let vibrancyView = UIVisualEffectView()
		let hostingController: UIHostingController<Content>
		
		init(content: Content) {
			hostingController = UIHostingController(rootView: content)
			hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			hostingController.view.backgroundColor = nil
			blurView.contentView.addSubview(vibrancyView)
			blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			vibrancyView.contentView.addSubview(hostingController.view)
			vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		}
		
		func update(content: Content, blurStyle: UIBlurEffect.Style, vibrancyStyle: UIVibrancyEffectStyle?) {
			hostingController.rootView = content
			let blurEffect = UIBlurEffect(style: blurStyle)
			blurView.effect = blurEffect
			if let vibrancyStyle = vibrancyStyle {
				vibrancyView.effect = UIVibrancyEffect(blurEffect: blurEffect, style: vibrancyStyle)
			} else {
				vibrancyView.effect = nil
			}
			hostingController.view.setNeedsDisplay()
		}
	}
}

// MARK: - Content-less Initializer

extension VisualEffectBlur where Content == EmptyView {
	init(blurStyle: UIBlurEffect.Style = .systemMaterial) {
		self.init(blurStyle: blurStyle, vibrancyStyle: nil) {
			EmptyView()
		}
	}
}

#endif
