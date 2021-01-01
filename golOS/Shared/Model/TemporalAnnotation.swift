//
//  TimeAnnotation.swift
//  golOS
//
//  Created by Felix Akira Green on 12/29/20.
//

import SwiftUI

/**

 /// ! No more than 6 fields per struct ...

 I can make rules that are also annotations... finally. This is good.

 Right now I'm doing everything manually → creating 1 datum per thing

 So working out would have MANY datums, here is the ones for who:
 	«me», Datum("with", .nominal("John Hill")), Datum("with", .nominal("Andy"))

 eventually → I could have an alias "$workoutGroup" that auto includes all that datums...

 same applies for routines... anything I want to "automate", speed up the recording of...

 and after we have 100,000s of datum, I can dump it into ML to auto-annotate my days, and even plan them

 */

/*
 TODO:

 - Data model for "dimensions"

 */

struct TemporalAnnotation: Identifiable, Codable {
	let id: UUID

	var wut: [Datum]
	var wen: [Datum]
	var how: [Datum]?
	var wer: [Datum]?
	var hoo: [Datum]?
	var wyy: [Datum]?

	init(id: UUID, group: String, start: Date, end: Date) {
		self.id = UUID()
		self.wut = [
			Datum(name: "group", data: .nominal(group))
		]
		self.wen = [
			Datum(name: "start", data: .time(start)),
			Datum(name: "end", data: .time(end))
		]
//		self.how = how

//		what: [Datum], when: [Datum], how: [Datum]
	}

	/**

	 Start with a basic ons that has:

	 what:
	 	group
	 	title/name?
	 	notes

	 when:
	 	start
	 	end

	 how:
	 	tags (ex: posture...)
	 	quality
	 	quantity

	 where:
	 	location

	 ——//——

	 this focuses on future extensibility because:

	 for when, later I can add:
	 - a .bool() for "all-day
	 - various or "recurring" rules
	 - "duration" instead of "end"

	 */
}

struct Datum: Codable {
	/**
	 It's like RDF:
	   a subject (“the sky”)
	   a predicate (“has the color”)
	   an object (“blue”)

	 Time {
	 	name: "start"
	 	data: .time(Date)
	 }

	 Exercise {
	 	name: "walking"
	 	data: .interval(Double)
	 	unit: "km"
	 }
	 */

	var name: String
	var data: DatumValueType
	var unit: String?

	init(name: String, data: DatumValueType) {
		self.name = name
		self.data = data
	}

	init(name: String, data: DatumValueType, unit: String) {
		self.name = name
		self.data = data
		self.unit = unit
	}
}

enum DatumValueType {
	case useless(String) /// String → Useless data is unique, discrete data with no potential relationship with the outcome variable. A useless feature has high cardinality. Ex: bank account numbers that were generated randomly.
	case nominal(String) /// String → Nominal data is made of discrete values with no numerical relationship between the different categories — mean and median are meaningless. Ex: Animal species; pig is not higher than bird and lower than fish. Nationality is another example of nominal data. There is group membership with no numeric order — being French, Mexican, or Japanese does not in itself imply an ordered relationship.
	case ordinal(Int) /// Int → Ordinal data are discrete integers that can be ranked or sorted. A defining characteristic is that the distance between any two numbers is not known. Ex: In a race, the distance between first and second may not be the same as the distance between second and third.
	case binary(Bool) /// Bool → Binary data is discrete data that can be in only one of two categories — either yes or no, 1 or 0, off or on, &c.
	case count(Int) /// Int, 0+ → Count data is discrete whole number data — no negative numbers here. Count data often has many small values, such as zero and one.
	case time(Date) /// Date → Time data is a cyclical, repeating continuous form of data. The relevant time features can be any period— daily, weekly, monthly, annual, etc.
	case interval(Double) /// Double → Interval data has equal spaces between the numbers and does not represent a temporal pattern. Ex: percentages, temperatures, and income.
	case text(String) /// String → Longer form of text
//	case image
//	case audio
//	case video
}

extension DatumValueType: Codable {
	enum Key: CodingKey {
		case rawValue
		case associatedValue
	}

	enum CodingError: Error {
		case unknownValue
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: Key.self)
		let rawValue = try container.decode(String.self, forKey: .rawValue)

		switch rawValue {
		case "useless":
			let value = try container.decode(String.self, forKey: .associatedValue)
			self = .useless(value)
		case "nominal":
			let value = try container.decode(String.self, forKey: .associatedValue)
			self = .nominal(value)
		case "ordinal":
			let value = try container.decode(Int.self, forKey: .associatedValue)
			self = .ordinal(value)
		case "binary":
			let value = try container.decode(Bool.self, forKey: .associatedValue)
			self = .binary(value)
		case "count":
			let value = try container.decode(Int.self, forKey: .associatedValue)
			self = .count(value)
		case "time":
			let value = try container.decode(Date.self, forKey: .associatedValue)
			self = .time(value)
		case "interval":
			let value = try container.decode(Double.self, forKey: .associatedValue)
			self = .interval(value)
		case "text":
			let value = try container.decode(String.self, forKey: .associatedValue)
			self = .text(value)
		default:
			throw CodingError.unknownValue
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: Key.self)

		switch self {
		case .useless(let value):
			try container.encode("useless", forKey: .rawValue)
			try container.encode(value, forKey: .associatedValue)
		case .nominal(let value):
			try container.encode("nominal", forKey: .rawValue)
			try container.encode(value, forKey: .associatedValue)
		case .ordinal(let value):
			try container.encode("ordinal", forKey: .rawValue)
			try container.encode(value, forKey: .associatedValue)
		case .binary(let value):
			try container.encode("binary", forKey: .rawValue)
			try container.encode(value, forKey: .associatedValue)
		case .count(let value):
			try container.encode("count", forKey: .rawValue)
			try container.encode(value, forKey: .associatedValue)
		case .time(let value):
			try container.encode("time", forKey: .rawValue)
			try container.encode(value, forKey: .associatedValue)
		case .interval(let value):
			try container.encode("interval", forKey: .rawValue)
			try container.encode(value, forKey: .associatedValue)
		case .text(let value):
			try container.encode("text", forKey: .rawValue)
			try container.encode(value, forKey: .associatedValue)
		}
	}
}

extension DatumValueType {
	
	var stringValue: String? {
		switch self {
		case .useless(let s), .nominal(let s), .text(let s):
			return s
		default:
			return nil
		}
	}
	
	var intValue: Int? {
		switch self {
		case .ordinal(let i), .count(let i):
			return i
		default:
			return nil
		}
	}
	
	var boolValue: Bool? {
		switch self {
		case .binary(let b):
			return b
		default:
			return nil
		}
	}
	
	var dateValue: Date? {
		switch self {
		case .time(let d):
			return d
		default:
			return nil
		}
	}
	
	var doubleValue: Double? {
		switch self {
		case .interval(let i):
			return i
		default:
			return nil
		}
	}
}

/**

 woah, I could do an extension ... that's a computed property on TemporalAnnotation

 for duration, or groupName, whatever
 that checks the datum for it

 */

func minutes(_ min: Double) -> TimeInterval {
	return 60 * min
}

extension TemporalAnnotation {
	struct EditData {
		var group: String = ""
		var start = Date().floor(precision: minutes(5))
		var end = Date().ceil(precision: minutes(5)).addingTimeInterval(minutes(10))
	}
	
	// TODO: make this easier
	var editGroup: String {
		guard let group = wut.first(where: { $0.name == "group" }) else {
			return EditData().group
		}
		return group.data.stringValue ?? EditData().group
	}
	
	var editStart: Date {
		guard let group = wen.first(where: { $0.name == "start" }) else {
			return EditData().start
		}
		return group.data.dateValue ?? EditData().start
	}
	
	var editEnd: Date {
		guard let group = wen.first(where: { $0.name == "end" }) else {
			return EditData().end
		}
		return group.data.dateValue ?? EditData().end
	}
	
	var editData: EditData {
		return EditData(group: editGroup, start: editStart, end: editEnd)
	}
}

extension Date {
	func round(precision: TimeInterval) -> Date {
		return round(precision: precision, rule: .toNearestOrAwayFromZero)
	}

	func ceil(precision: TimeInterval) -> Date {
		return round(precision: precision, rule: .up)
	}

	func floor(precision: TimeInterval) -> Date {
		return round(precision: precision, rule: .down)
	}

	private func round(precision: TimeInterval, rule: FloatingPointRoundingRule) -> Date {
		let seconds = (timeIntervalSinceReferenceDate / precision).rounded(rule) * precision
		return Date(timeIntervalSinceReferenceDate: seconds)
	}
}
