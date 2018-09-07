//
//  Cache.swift
//  Random Users
//
//  Created by William Bundy on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

struct Cache<Key:Hashable, Value>
{
	var queue = DispatchQueue(label: "com.wb.Cache.queue")
	var items:[Key:Value] = [:]

	mutating func store(_ key:Key, _ value: Value)
	{
		queue.sync {
			items[key] = value
		}
	}

	func retrieve(_ key:Key) -> Value?
	{
		return queue.sync { items[key] }
	}
}
