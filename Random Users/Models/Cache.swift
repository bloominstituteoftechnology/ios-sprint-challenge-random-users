//
//  Cache.swift
//  Random Users
//
//  Created by Jeffrey Santana on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
	
	private var cachedItems = [Key: Value]()
	private let queue = DispatchQueue(label: "MyCacheQueue")
	
	func cache(value: Value, for key: Key) {
		queue.async {
			self.cachedItems.updateValue(value, forKey: key)
		}
	}
	
	func value(for key: Key) -> Value? {
		return queue.sync { () -> Value? in
			cachedItems[key]
		}
	}
}
