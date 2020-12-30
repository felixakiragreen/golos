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
		NavigationView {
			ContentView()
		}
//		.preferredColorScheme(.dark)←
	}
}


struct ContentView: View {
	// MARK: - PROPS
	@State private var isPresented = false

	// MARK: - BODY
	var body: some View {
		ZStack {
			Color("grey.sys.100").edgesIgnoringSafeArea(.all)
			VStack {
				HStack {
//					Text("Hello, world!")
//						.padding()
				}
				Spacer()
				VStack(spacing: 16) {
					GroupAnnotationDimension(colorHue: .red) {
						Group {
						LazyVGrid(columns: [
							GridItem.init(.flexible(), alignment: .trailing),
							GridItem.init(.flexible(), alignment: .leading)
						]) {
							ButtonAnnotationType(
								colorHue: .purple,
								title: "sleep",
								icon: "bed.double.fill",
								trailing: true) {
								isPresented = true
							}
							ButtonAnnotationType(
								colorHue: .blue,
								title: "social",
								icon: "person.3.fill") {
								isPresented = true
							}
							ButtonAnnotationType(
								colorHue: .red,
								title: "fitness",
								icon: "figure.walk",
								trailing: true) {
								isPresented = true
							}
							ButtonAnnotationType(
								colorHue: .green,
								title: "diet",
								icon: "mouth.fill") {
								isPresented = true
							}
						}
//						VStack {
//							HStack {
//								ButtonAnnotationType(
//									colorHue: .purple,
//									title: "sleep",
//									icon: "bed.double.fill",
//									trailing: true) {
//									isPresented = true
//								}
//								ButtonAnnotationType(
//									colorHue: .blue,
//									title: "social",
//									icon: "person.3.fill") {
//									isPresented = true
//								}
//							}
//							HStack {
//								ButtonAnnotationType(
//									colorHue: .red,
//									title: "fitness",
//									icon: "figure.walk",
//									trailing: true) {
//									isPresented = true
//								}
//								ButtonAnnotationType(
//									colorHue: .green,
//									title: "diet",
//									icon: "mouth.fill") {
//									isPresented = true
//								}
//							}
//						}
						}
					}

					HStack(alignment: .firstTextBaseline) {
						Spacer()
						Text("productive")
							.foregroundColor(Color("green.sys.900"))
							.font(Font.system(.title2, design: .rounded))
							.bold()
						Text("strive")
							.foregroundColor(Color("green.sys.700"))
						Spacer()
					}
					.frame(minHeight: 100)
					.background(Color("green.sys.300"))

					HStack(alignment: .firstTextBaseline) {
						Spacer()
						Text("non-productive")
							.foregroundColor(Color("blue.sys.900"))
							.font(Font.system(.title2, design: .rounded))
							.bold()
						Text("thrive")
							.foregroundColor(Color("blue.sys.700"))
						Spacer()
					}
					.frame(minHeight: 100)
					.background(Color("blue.sys.300"))
				}
			}
		}
//		.navigationTitle("Daily")
		.sheet(isPresented: $isPresented) {
			NavigationView {
				DetailView()
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
	var colorHue: ColorHue
	var content: () -> Content
	
	var body: some View {
		VStack(spacing: 8) {
			
			HStack {
				LazyVGrid(columns: [
					GridItem.init(.flexible(), alignment: .trailing),
					GridItem.init(.flexible(), alignment: .leading)
				]) {
					Text("critical")
						.foregroundColor(ColorPreset(hue: colorHue, lum: .nearBlack).getColor())
						.font(Font.system(.title2, design: .rounded))
						.bold()
					Text("survive")
						.foregroundColor(ColorPreset(hue: colorHue, lum: .dark).getColor())
				}
			}//: LABEL
			.padding(.horizontal, 12)
			
			HStack {
				content()
			}//: CONTENT
			.padding()
			.frame(maxWidth: .infinity)
			.background(
				ZStack {
					ColorPreset(hue: colorHue, lum: .extraLight).getColor()
					
					FlatHexagonalShape(body: .infinity)
						.inset(by: -6)
						.fill(ColorPreset(hue: .grey, lum: .nearWhite).getColor())
					
					FlatHexagonalShape(body: .infinity)
						.inset(by: 3)
//						.fill(ColorPreset(hue: .grey, lum: .extraLight).getColor())
						.fill(
							LinearGradient(gradient:Gradient.init(colors: [
								ColorPreset(hue: .grey, lum: .extraLight).getColor(),
								ColorPreset(hue: .grey, lum: .nearWhite).getColor(),
								ColorPreset(hue: .grey, lum: .extraLight).getColor()
							]),
							startPoint: .leading, endPoint: .trailing
							)
						)

					FlatHexagonalShape(body: .infinity)
						.strokeBorder(
							LinearGradient(gradient:Gradient.init(colors: [
								ColorPreset(hue: .red, lum: .normal).getColor(),
								ColorPreset(hue: .red, lum: .nearWhite).getColor(),
								ColorPreset(hue: .red, lum: .normal).getColor()
							]),
							startPoint: .leading, endPoint: .trailing
							),
							lineWidth: 1
						)
				}
			)
		}
		
	}
}

struct ButtonAnnotationType: View {
	var colorHue: ColorHue
	var title: String
	var icon: String
	var trailing: Bool = false
	var action: () -> Void
	
	var body: some View {
		Button(action: action) {
			HStack(spacing: 12) {
				if trailing {
					bodyText
					bodyIcon
				} else {
					bodyIcon
					bodyText
				}
			}
			.foregroundColor(ColorPreset(hue: colorHue, lum: .extraDark).getColor())
			.padding(6)
			.padding(.horizontal, 12)
//			.padding(.leading, trailing ? 18 : 12)
//			.padding(.trailing, trailing ? 12 : 18)
			.background(
				FlatHexagon(
					fill: ColorPreset(hue: colorHue, lum: .extraLight).getColor(),
					length: .infinity
				)
			)
		}
	}
	
	var bodyIcon: some View {
		ZStack {
			PointyHexagonalShape()
				.fill(ColorPreset(hue: colorHue, lum: .dark).getColor())
				.hexagonalFrame(height: 12)
				.overlay(
					PointyHexagonalShape()
						.inset(by: -6)
						.strokeBorder(ColorPreset(hue: .red, lum: .medium).getColor(), lineWidth: 3)
				)
//			Image(systemName: "\(icon)")
		}.padding(.horizontal, 6)
	}
	
	var bodyText: some View {
		HStack(spacing: 0) {
			Text("~")
				.font(Font.system(.body, design: .monospaced))
				.foregroundColor(ColorPreset(hue: .red, lum: .dark).getColor())
			Text(title)
				.font(Font.system(.headline, design: .monospaced))
			
		}
	}
}
