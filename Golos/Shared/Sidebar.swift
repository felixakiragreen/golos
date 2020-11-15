/*
 Sidebar.swift
 Golos

 Created by Felix Akira Green on 11/1/20.

 Abstract:
 App's navigation
 */

import SwiftUI

struct Sidebar: View {
	enum NavigationItem {
		case setup
		case overview
		case scratchpad
		case feedback
		case updates
	}
	
	@State private var selection: NavigationItem? = .overview
	
	var body: some View {
		sidebar.toolbar {
			ToolbarItem(placement: .navigation) {
				#if os(macOS)
				Button(action: toggleSidebar, label: {
					Image(systemName: "sidebar.left")
				})
				#endif
			}
		}
	}
	
	var sidebar: some View {
		List(selection: $selection) {
			// Setup
			Group {
				NavigationLink(
					destination: SetupView(),
					tag: NavigationItem.setup,
					selection: $selection
				) {
					Label("Setup", systemImage: "figure.wave")
				}.tag(NavigationItem.setup)
			}
			
			// Overview
			Group {
				NavigationLink(
					destination: Overview(),
					tag: NavigationItem.overview,
					selection: $selection
				) {
					Label("Overview", systemImage: "hexagon")
				}.tag(NavigationItem.overview)
			}
	
			Spacer()
			
			// Scratchpad
//			Group {
//				NavigationLink(
//					destination: Overview(),
//					tag: NavigationItem.scratchpad,
//					selection: $selection
//				) {
//					Label("Scratchpad", systemImage: "pencil.and.outline")
//				}.tag(NavigationItem.scratchpad)
//
//				Text("TODO: quick add")
//				Text("What do I want to remember?")
//			}
			
//			Spacer()
			
			// Feedback
			Group {
				NavigationLink(
					destination: Overview(),
					tag: NavigationItem.feedback,
					selection: $selection
				) {
					Label("Feedback", systemImage: "lightbulb")
				}.tag(NavigationItem.feedback)
		
//				Text("TODO: quick add")
			}
			
			Spacer()
			
			// Updates
			Group {
				NavigationLink(
					destination: Overview(),
					tag: NavigationItem.updates,
					selection: $selection
				) {
					Label("Updates", systemImage: "sparkles")
				}.tag(NavigationItem.updates)
			}
		}
		.listStyle(SidebarListStyle())
	}
	
	private func toggleSidebar() {
		#if os(macOS)
		NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
		#endif
	}
}

struct Sidebar_Previews: PreviewProvider {
	static var previews: some View {
		Sidebar()
	}
}
