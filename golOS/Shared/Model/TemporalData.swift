//
//  TemporalData.swift
//  golOS
//
//  Created by Felix Akira Green on 1/3/21.
//

import Foundation

class TemporalData: ObservableObject {
	private static var documentsFolder: URL {
		do {
			return try FileManager.default.url(for: .documentDirectory,
			                                   in: .userDomainMask,
			                                   appropriateFor: nil,
			                                   create: false)
		} catch {
			fatalError("Can't find documents directory.")
		}
	}

	private static var fileURL: URL {
		return documentsFolder.appendingPathComponent("temporalData.json")
	}

	@Published var daily: [DailyAnnotation] = []

	func load() {
		DispatchQueue.global(qos: .background).async { [weak self] in
			guard let data = try? Data(contentsOf: Self.fileURL) else {
				#if DEBUG
					DispatchQueue.main.async {
						self?.daily = DailyAnnotation.testData
					}
				#endif
				return
			}
			guard let dailyAnnotations = try? JSONDecoder().decode([DailyAnnotation].self, from: data) else {
				fatalError("Can't decode saved scrum data.")
			}
			DispatchQueue.main.async {
				self?.daily = dailyAnnotations
			}
		}
	}

	func save() {
		DispatchQueue.global(qos: .background).async { [weak self] in
			guard let daily = self?.daily else {
				fatalError("Self out of scope")
			}
			guard let data = try? JSONEncoder().encode(daily) else {
				fatalError("Error encoding data")
			}
			do {
				let outfile = Self.fileURL
				try data.write(to: outfile)
			} catch {
				fatalError("Can't write to file")
			}
		}
	}
}
