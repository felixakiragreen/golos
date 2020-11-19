import SwiftUI

var selectedDate = Date()

let selectedDateComponents: DateComponents = Calendar.current.dateComponents([
	.year,
	.quarter,
	.month,
	.weekOfYear,
	.day
], from: selectedDate)

print(selectedDateComponents)

// let formatter = DateComponentsFormatter()
// formatter.unitsStyle = .positional
////formatter.includesApproximationPhrase = true
////formatter.includesTimeRemainingPhrase = true
////formatter.allowedUnits = [.year]
//
// let outputString = formatter.string(from: selectedDateComponents) ?? ""
//
// print(outputString)

let dateFormatterMonth = DateFormatter()
// dateFormatter.dateStyle = .
// dateFormatter.timeStyle = .none
dateFormatterMonth.setLocalizedDateFormatFromTemplate("MMM")

print(dateFormatterMonth.string(from: selectedDate))

// let currentMonthDateFormat = DateFormatter.dateFormat(fromTemplate: "MMM", options: 0, locale: Locale.current)!
//
// let m = DateFormatter.string(<#T##self: DateFormatter##DateFormatter#>)
//
// print("\()m" )

let hours: [Int] = Array(stride(from: 0, to: 48, by: 6))
print(hours)

let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .full
dateFormatter.timeStyle = .long
	
let test = Calendar.current.date(
	bySettingHour: 0,
	minute: 0,
	second: 0,
	of: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
) ?? Date()

print("test → \(dateFormatter.string(from: test))")

let test2 = Calendar.current.date(from:
	DateComponents(calendar: Calendar.current, day: 1, hour: 8, minute: 30)
)!

print("test2 → \(dateFormatter.string(from: test2))")

print("\(Date())")

let test3 = Calendar.current.date(byAdding:
	DateComponents(calendar: Calendar.current, hour: 1, minute: 0), to: Date()) ?? Date()

print("test3 → \(dateFormatter.string(from: test3))")

let test4 = Calendar.current.date(
	bySettingHour: 0,
	minute: 0,
	second: 0,
	of: Date()
) ?? Date()

print("test4 → \(dateFormatter.string(from: test4))")


