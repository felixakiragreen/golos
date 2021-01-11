//
//  Collection+optional.swift
//  golOS
//
//  Created by Felix Akira Green on 1/3/21.
//

import Foundation

extension Collection {
	/// This allows for indexes to be fetched safely
	subscript(optional i: Index) -> Iterator.Element? {
		return self.indices.contains(i) ? self[i] : nil
	}
}
