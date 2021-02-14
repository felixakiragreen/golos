//
//  Dictionary+optional.swift
//  FutureUI
//
//  Created by Felix Akira Green on 2/5/21.
//

import Foundation

/// Allows for an optional key to be used for a DIctionary
extension Dictionary {
	subscript(optional k: Key?) -> Value? {
		get {
			if let key = k {
				return self[key]
			}
			return nil
		}
		set(newValue) {
			if let key = k {
				self[key] = newValue
			}
		}
	}
}
