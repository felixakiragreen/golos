//
//  Comparable+clamp.swift
//  FutureUI
//
//  Created by Felix Akira Green on 2/5/21.
//

import Foundation

/// Returns the input value clamped to the lower and upper limits.
func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
	return min(max(value, lower), upper)
}
