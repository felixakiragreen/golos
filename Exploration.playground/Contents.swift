import SwiftUI

var selectedDate: Date = Date()

let selectedDateComponents: DateComponents = Calendar.current.dateComponents([
	.year,
	.quarter,
	.month,
	.weekOfYear,
	.day
], from: selectedDate)

print(selectedDateComponents)

//let formatter = DateComponentsFormatter()
//formatter.unitsStyle = .positional
////formatter.includesApproximationPhrase = true
////formatter.includesTimeRemainingPhrase = true
////formatter.allowedUnits = [.year]
//
//let outputString = formatter.string(from: selectedDateComponents) ?? ""
//
//print(outputString)

let dateFormatter = DateFormatter()
//dateFormatter.dateStyle = .
//dateFormatter.timeStyle = .none
dateFormatter.setLocalizedDateFormatFromTemplate("MMM")

print(dateFormatter.string(from: selectedDate))

//let currentMonthDateFormat = DateFormatter.dateFormat(fromTemplate: "MMM", options: 0, locale: Locale.current)!
//
//let m = DateFormatter.string(<#T##self: DateFormatter##DateFormatter#>)
//
//print("\()m" )
