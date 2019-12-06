//
//  Cache.swift
//  Random Users
//
//  Created by Jonalynn Masters on 12/6/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
class Cache<Key: Hashable, Value> {

    private var cachedItems: [Key: Value] = [:]
    let queue = DispatchQueue(label: "CacheSerialQueue")

    func cache(value: Value, for key: Key) {
        queue.async {
            self.cachedItems[key] = value
        }
    }

    func value(for key: Key) -> Value? {
        return queue.sync {
            cachedItems[key]
        }
    }
}
