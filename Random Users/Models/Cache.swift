//
//  Cache.swift
//  Random Users
//
//  Created by Chris Dobek on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {

    private var storage: [Key : Value] = [:]
    private var queue = DispatchQueue(label: "Cache queue")

    func cache(value: Value, for key: Key) {
        queue.async {
            self.storage[key] = value
        }
    }

    func value(for key: Key) -> Value? {
        return queue.sync {
            storage[key]
        }
    }
}
