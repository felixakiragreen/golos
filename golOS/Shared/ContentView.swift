//
//  ContentView.swift
//  Shared
//
//  Created by Felix Akira Green on 12/28/20.
//

import SwiftUI

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
//		NavigationView {
			ContentView()
//		}
//		.preferredColorScheme(.dark)←
	}
}

struct ContentView: View {
	// MARK: - PROPS

	@State var isPresented = false
	@State var data: TemporalAnnotation.EditData = TemporalAnnotation.EditData()

	// MARK: - BODY

	var body: some View {
		ZStack {
			Color("grey.sys.100").edgesIgnoringSafeArea(.all)
			VStack {
				HStack {
					WIP(label: "visualization → ALL logged items in a day as hexagonal icons")
						.padding()
				}
//				.frame(minHeight: 80)
//				Spacer()
				HStack {
					WIP(label: "visualization → day/night cycle, circadian rhythm")
						.padding()
				}
//				.frame(minHeight: 80)
//				Spacer()
				VStack(spacing: 12) {
					GroupAnnotationDimension(title: "critical", notes: "survive") {
						Group {
							LazyVGrid(columns: [
								GridItem(.flexible(), alignment: .trailing),
								GridItem(.flexible(), alignment: .leading)
							]) {
								ButtonAnnotationType(
									hue1: .purple,
									title: "sleep",
									trailing: true
								) {
									// selectedGroup = "sleep"
									isPresented = true
									data.group = "sleep"
								}
								ButtonAnnotationType(
									hue1: .blue,
									title: "social"
								) {
									isPresented = true
								}
								ButtonAnnotationType(
									hue1: .red,
									title: "fitness",
									trailing: true
								) {
									isPresented = true
								}
								ButtonAnnotationType(
									hue1: .green,
									title: "diet"
								) {
									isPresented = true
								}
							}
						}
					}
					.parentHueStyle(.red)

					GroupAnnotationDimension(title: "productive", notes: "strive") {
						Group {
							LazyVGrid(columns: [
								GridItem(.flexible(), alignment: .trailing),
								GridItem(.flexible(), alignment: .leading)
							]) {
								ButtonAnnotationType(
									hue1: .red,
									title: "work",
									trailing: true
								) {
									isPresented = true
								}
								ButtonAnnotationType(
									hue1: .purple,
									title: "network"
								) {
									isPresented = true
								}
								ButtonAnnotationType(
									hue1: .orange,
									title: "clean",
									trailing: true
								) {
									isPresented = true
								}
								ButtonAnnotationType(
									hue1: .blue,
									title: "mental"
								) {
									isPresented = true
								}
								ButtonAnnotationType(
									hue1: .yellow,
									title: "learn",
									trailing: true
								) {
									isPresented = true
								}
								ButtonAnnotationType(
									hue1: .green,
									title: "habit"
								) {
									isPresented = true
								}
							}
						}
					}
					.parentHueStyle(.green)
					
					GroupAnnotationDimension(title: "nonproductive", notes: "thrive") {
						Group {
							LazyVGrid(columns: [
								GridItem(.flexible(), alignment: .trailing),
								GridItem(.flexible(), alignment: .leading)
							]) {
								ButtonAnnotationType(
									hue1: .red,
									title: "chill",
									trailing: true
								) {
									isPresented = true
								}
								ButtonAnnotationType(
									hue1: .purple,
									title: "play"
								) {
									isPresented = true
								}
								ButtonAnnotationType(
									hue1: .orange,
									title: "media",
									trailing: true
								) {
									isPresented = true
								}
								ButtonAnnotationType(
									hue1: .blue,
									title: "hobby"
								) {
									isPresented = true
								}
								ButtonAnnotationType(
									hue1: .yellow,
									title: "internet",
									trailing: true
								) {
									isPresented = true
								}
								ButtonAnnotationType(
									hue1: .green,
									title: "positive"
								) {
									isPresented = true
								}
							}
						}
					}
					.parentHueStyle(.blue)
				}
			}
		}
//		.navigationTitle("Daily")
		.sheet(isPresented: $isPresented) {
			NavigationView {
				DetailView(editData: $data)
					.navigationBarItems(leading: Button("Dismiss") {
						isPresented = false
					}
//					, trailing: Button("Add") {
//						let newScrum = DailyScrum(title: newScrumData.title, attendees: newScrumData.attendees,
//														  lengthInMinutes: Int(newScrumData.lengthInMinutes), color: newScrumData.color)
//						scrums.append(newScrum)
//						isPresented = false
//					}
					)
//				EditView(scrumData: $newScrumData)
			}
		}
//		.frame(minWidth: .infinity, minHeight: .infinity)
	}
}

// MARK: - SUBVIEWS

struct GroupAnnotationDimension<Content: View>: View {
	@Environment(\.parentHue) var parentHue
	
	var title: String
	var notes: String
	var content: () -> Content

	var body: some View {
		VStack(spacing: 0) {
			header
				.padding(.bottom, 4)

			HStack {
				content()
			} //: CONTENT
			.padding(.vertical, 6)
			.frame(maxWidth: .infinity)
			.background(
				ZStack {
					ColorPreset(hue: parentHue, lum: .extraLight).getColor()
						.padding(.vertical, 6)

					FlatHexagonalShape(body: .infinity)
						.inset(by: -6)
						.fill(ColorPreset(hue: .grey, lum: .nearWhite).getColor())
//						.padding(6)

					FlatHexagonalShape(body: .infinity)
						.inset(by: 3)
//						.fill(ColorPreset(hue: .grey, lum: .extraLight).getColor())
						.fill(
							LinearGradient(gradient: Gradient(colors: [
								ColorPreset(hue: .grey, lum: .light).getColor(),
								ColorPreset(hue: .grey, lum: .nearWhite).getColor(),
								ColorPreset(hue: .grey, lum: .light).getColor()
							]),
							startPoint: .leading, endPoint: .trailing)
						)

					FlatHexagonalShape(body: .infinity)
						.strokeBorder(
							LinearGradient(gradient: Gradient(colors: [
								ColorPreset(hue: parentHue, lum: .medium).getColor(),
								ColorPreset(hue: parentHue, lum: .nearWhite).getColor(),
								ColorPreset(hue: parentHue, lum: .medium).getColor()
							]),
							startPoint: .leading, endPoint: .trailing),
							lineWidth: 1
						)
				}
			)
		}
	}

	var header: some View {
		HStack(alignment: .firstTextBaseline) {
			Spacer()
			Text(title)
				.foregroundColor(ColorPreset(hue: parentHue, lum: .nearBlack).getColor())
				.font(Font.system(.headline, design: .rounded))
//				.bold()
			Text(notes)
				.foregroundColor(ColorPreset(hue: parentHue, lum: .dark).getColor())
			Spacer()
		} //: LABEL
		.padding(.horizontal, 12)
		.padding(.vertical, 8)
		.background(
			Rectangle()
				.fill(ColorPreset(hue: parentHue, lum: .extraLight).getColor())
				.mask(
					FlatHexagonalShape(body: .infinity)
						.frame(height: 110)
						.padding(.horizontal, 40)
						.offset(x: 0, y: 40)
				)
		)
	}
}


// TODO: pick up RED from mini environment variable
// TODO: bind presented/selectedGroup in order
// TODO: maybe it shouldn't be a modal like this
struct ButtonAnnotationType: View {
	@Environment(\.parentHue) var parentHue
	
	var hue1: ColorHue
	var title: String
	var trailing: Bool = false
	var action: () -> Void

	var body: some View {
		Button(action: action) {
			HStack(spacing: 9) {
				if trailing {
					bodyText
					bodyIcon
				} else {
					bodyIcon
					bodyText
				}
			}
			.foregroundColor(ColorPreset(hue: hue1, lum: .extraDark).getColor())
			.padding(9)
			.padding(.horizontal, 6)
//			.padding(.leading, trailing ? 18 : 12)
//			.padding(.trailing, trailing ? 12 : 18)
			.background(
				FlatHexagonalShape(body: .infinity)
					.fill(ColorPreset(hue: hue1, lum: .extraLight).getColor())
					.overlay(
						FlatHexagonalShape(body: .infinity)
							.inset(by: -2)
							.strokeBorder(
								LinearGradient(gradient: Gradient(colors: [
									ColorPreset(hue: parentHue, lum: .medium).getColor(),
									ColorPreset(hue: parentHue, lum: .nearWhite).getColor(),
									ColorPreset(hue: parentHue, lum: .medium).getColor()
								]),
								startPoint: .leading, endPoint: .trailing),
								lineWidth: 1
							)
					)
			)
		}
	}

	var bodyIcon: some View {
		ZStack {
			PointyHexagonalShape()
				.fill(ColorPreset(hue: hue1, lum: .medium).getColor())
				.hexagonalFrame(height: 16)
				.overlay(
					PointyHexagonalShape()
						.inset(by: -3)
						.strokeBorder(ColorPreset(hue: parentHue, lum: .dark).getColor(), lineWidth: 1)
				)
//			Image(systemName: "\(icon)")
		}.padding(.horizontal, 6)
	}

	var bodyIcon2: some View {
		ZStack {
			PointyHexagonalShape()
				.fill(ColorPreset(hue: parentHue, lum: .light).getColor())
				.hexagonalFrame(height: 16)
				.overlay(
					PointyHexagonalShape()
						.inset(by: -4)
						.strokeBorder(ColorPreset(hue: hue1, lum: .medium).getColor(), lineWidth: 2)
				)
//			Image(systemName: "\(icon)")
		}.padding(.horizontal, 6)
	}

	var bodyText: some View {
		HStack(spacing: 0) {
			Text("~")
				.font(Font.system(.body, design: .monospaced))
				.foregroundColor(ColorPreset(hue: parentHue, lum: .dark).getColor())
			Text(title)
//				.font(Font.system(.headline, design: .monospaced))
		}
	}
}
