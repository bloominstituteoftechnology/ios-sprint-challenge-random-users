//
//  Cache.swift
//  Random Users
//
//  Created by Hector Steven on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


struct Cache<Key: Hashable, Value> {
	private (set) var cache: [Key: Value] = [:]
	let q = DispatchQueue(label: "cache")
	
	mutating func cache(value: Value, for key: Key) {
		q.sync {
			if let _ = cache[key] { return }
			cache[key] = value
		}
	}
	
	func value(for key: Key) -> Value? {
		var value: Value?
		q.sync {
			value = cache[key]
		}
		
		return value
	}
	
}
