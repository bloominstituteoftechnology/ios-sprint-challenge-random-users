//
//  Cache.swift
//  Random Users
//
//  Created by Percy Ngan on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key: Hashable {

	private var queue = DispatchQueue(label: "Queue")

	var imageCache: [Key: Value] = [:]

	func cache(value: Value, for key: Key) {
		queue.async {
			self.imageCache[key] = value
		}
	}

	func fetch(key: Key) -> Value? {
		return queue.sync {
			imageCache[key]
		}
	}
}
