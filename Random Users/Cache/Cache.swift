
import Foundation
import UIKit
import CoreData

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
