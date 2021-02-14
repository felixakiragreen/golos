//
//  Collection+optional.swift
//  FutureUI
//
//  Created by Felix Akira Green on 1/24/21.
//

import Foundation

extension Collection {
	/// This allows for ANY index to be fetched & set safely
	subscript(optional i: Index) -> Iterator.Element? {
		get {
			return self.indices.contains(i) ? self[i] : nil
		}
		set(newValue) {
			if self.indices.contains(i) {
				self[optional: i] = newValue
			}
		}
	}
	
	/// This allows for an OPTIONAL index to be fetched & set safely
	subscript(optional i: Index?) -> Iterator.Element? {
		get {
			if let index = i {
				return self[optional: index]
			}
			return nil
		}
		set(newValue) {
			if let index = i {
				self[optional: index] = newValue
			}
		}
	}
}
