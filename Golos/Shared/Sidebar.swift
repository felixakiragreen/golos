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
		case warroom
		case scratchpad
		case feedback
		case updates
	}
	
	@State private var selection: NavigationItem? = .warroom
	
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
			Group {
				NavigationLink(
					destination: WarRoomView(),
					tag: NavigationItem.warroom,
					selection: $selection
				) {
					Label("War Room", systemImage: "crown")
				}.tag(NavigationItem.warroom)
			}
	
			Spacer()
			
			Group {
				NavigationLink(
					destination: WarRoomView(),
					tag: NavigationItem.scratchpad,
					selection: $selection
				) {
					Label("Scratchpad", systemImage: "pencil.and.outline")
				}.tag(NavigationItem.scratchpad)
		
				Text("TODO: quick add")
			}
			
			Spacer()
			
			Group {
				NavigationLink(
					destination: WarRoomView(),
					tag: NavigationItem.feedback,
					selection: $selection
				) {
					Label("Feedback", systemImage: "lightbulb")
				}.tag(NavigationItem.feedback)
		
				Text("TODO: quick add")
			}
			
			Spacer()
			
			Group {
				NavigationLink(
					destination: WarRoomView(),
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
