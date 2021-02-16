//
//  SolarSkyGradientView.swift
//  golOS
//
//  Created by Felix Akira Green on 2/16/21.
//

import SwiftUI

// MARK: - PREVIEW
struct SolarSkyGradientView_Previews: PreviewProvider {
	static var previews: some View {
		GeometryReader { geometry in
			SolarSkyGradientView(
				temporalConfig: TemporalConfig(),
				cursorTime: Date()
			)
			.environment(\.temporalSpec, TemporalSpec(contentSize: geometry.size.height))
			.environment(\.devDebug, true)
			.environmentObject(SolarModel())
		}
	}
}

struct SolarSkyGradientView: View {
	// MARK: - PROPS

	@Environment(\.temporalSpec) var temporalSpec
	@EnvironmentObject var solarModel: SolarModel

	var temporalConfig: TemporalConfig
	var cursorTime: Date

	// MARK: - BODY

	var body: some View {
		ZStack(alignment: .top) {
			if let solarPhaseProgress = solarModel.getPhaseProgressFor(time: cursorTime) {
				SkyGradientView(solarPhaseProgress: solarPhaseProgress)
			}
		} //: ZStack
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
}

struct SkyGradientView: View {
	// MARK: - PROPS

	@Environment(\.devDebug) var devDebug

	var solarPhaseProgress: SolarPhaseProgress

	// MARK: - BODY

	var body: some View {
		ZStack(alignment: .top) {
			Rectangle()
				.modifier(
					AnimatableGradient(
						all: gradients,
						fromIndex: gradientProgressValue.from,
						toIndex: gradientProgressValue.to,
						pct: CGFloat(gradientProgressValue.pct)
					)
				)
			if devDebug {
				Text("\(getSolarPhaseLabel(solarPhaseProgress)) \(gradientProgressValue.pct, specifier: "%.2f")")
					.font(.largeTitle)
					.padding(.top, 164)
			}
		} //: ZStack
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}

	// MARK: - COMPUTES
	
	typealias GradientValue = (from: Int, to: Int, pct: Double)

	var gradientProgressValue: GradientValue {
		switch solarPhaseProgress {
			case let SolarPhaseProgress.night(progress):
				return (from: 1,
				        to: 0,
				        pct: progress)
			case let SolarPhaseProgress.dawn(progress):
				return (from: 1,
				        to: 2,
				        pct: progress)
			case let SolarPhaseProgress.rise(progress):
				return (from: 2,
				        to: 2,
				        pct: progress)
			case let SolarPhaseProgress.shine(progress):
				return (from: 2,
				        to: 3,
				        pct: progress)
			case let SolarPhaseProgress.day(progress):
				return (from: 4,
				        to: 3,
				        pct: 1 - progress)
			case let SolarPhaseProgress.set(progress):
				return (from: 2,
				        to: 2,
				        pct: progress)
			case let SolarPhaseProgress.dusk(progress):
				return (from: 2,
				        to: 1,
				        pct: progress)
		}
	}

	// MARK: - gradients

	var gradients: [[NativeStop]] {
		[
			night, // 0
			twilight, // 1
			sun, // 2
			shine, // 3
			day, // 4
		]
	}
	
	let night: [NativeStop] = [
		(color: NativeColor(Color(#colorLiteral(red: 0.003380405018, green: 0.01248565037, blue: 0.1030821726, alpha: 1))), location: 0.0),
		(color: NativeColor(Color(#colorLiteral(red: 0.003690367797, green: 0.02489320002, blue: 0.1723413169, alpha: 1))), location: 0.33),
		(color: NativeColor(Color(#colorLiteral(red: 0.01167470682, green: 0.04773455113, blue: 0.3371214271, alpha: 1))), location: 0.66),
		(color: NativeColor(Color(#colorLiteral(red: 0.0904847458, green: 0.002781496383, blue: 0.4793588519, alpha: 1))), location: 1.0),
	]

	let twilight: [NativeStop] = [
		(color: NativeColor(Color(#colorLiteral(red: 0.0009479976725, green: 0.02773871832, blue: 0.2280530632, alpha: 1))), location: 0.0),
		(color: NativeColor(Color(#colorLiteral(red: 0.003361887531, green: 0.16669783, blue: 0.479382813, alpha: 1))), location: 0.33),
		(color: NativeColor(Color(#colorLiteral(red: 0.1716162264, green: 0.1648572981, blue: 0.7561655641, alpha: 1))), location: 0.66),
		(color: NativeColor(Color(#colorLiteral(red: 0.5243727565, green: 0.1154649928, blue: 0.7274202704, alpha: 1))), location: 1.0),
	]

	let sun: [NativeStop] = [
		(color: NativeColor(Color(#colorLiteral(red: 0.1687308848, green: 0.09176445752, blue: 0.3746856749, alpha: 1))), location: 0.0),
		(color: NativeColor(Color(#colorLiteral(red: 0.5273597836, green: 0.04536166787, blue: 0.1914333701, alpha: 1))), location: 0.33),
		(color: NativeColor(Color(#colorLiteral(red: 0.9155419469, green: 0.4921894073, blue: 0.1403514445, alpha: 1))), location: 0.66),
		(color: NativeColor(Color(#colorLiteral(red: 0.9246239066, green: 0.8353297114, blue: 0.01127522066, alpha: 1))), location: 1.0),
	]

	let shine: [NativeStop] = [
		(color: NativeColor(Color(#colorLiteral(red: 0.0158313401, green: 0.005890237633, blue: 0.6395550966, alpha: 1))), location: 0.0),
		(color: NativeColor(Color(#colorLiteral(red: 0.00617591897, green: 0.3323536515, blue: 0.6396250129, alpha: 1))), location: 0.33),
		(color: NativeColor(Color(#colorLiteral(red: 0.9244585633, green: 0.9151363969, blue: 0.5425032377, alpha: 1))), location: 0.66),
		(color: NativeColor(Color(#colorLiteral(red: 0.9897723794, green: 0.8248019814, blue: 0.1941889524, alpha: 1))), location: 1.0),
	]

	let day: [NativeStop] = [
		(color: NativeColor(Color(#colorLiteral(red: 0.009109710343, green: 0.2355630994, blue: 0.7201706767, alpha: 1))), location: 0.0),
		(color: NativeColor(Color(#colorLiteral(red: 0.1112611368, green: 0.4668209553, blue: 0.8761388063, alpha: 1))), location: 0.33),
		(color: NativeColor(Color(#colorLiteral(red: 0.5453876257, green: 0.7670046687, blue: 0.958891809, alpha: 1))), location: 0.66),
		(color: NativeColor(Color(#colorLiteral(red: 0.9247719646, green: 0.9830601811, blue: 0.9897001386, alpha: 1))), location: 1.0),
	]
}

// MARK: - HELPERS

fileprivate func getSolarPhaseLabel(_ phase: SolarPhaseProgress) -> String {
	switch phase {
		case SolarPhaseProgress.night: return "night"
		case SolarPhaseProgress.dawn: return "dawn"
		case SolarPhaseProgress.rise: return "rise"
		case SolarPhaseProgress.shine: return "shine"
		case SolarPhaseProgress.day: return "day"
		case SolarPhaseProgress.set: return "set"
		case SolarPhaseProgress.dusk: return "dusk"
	}
}
