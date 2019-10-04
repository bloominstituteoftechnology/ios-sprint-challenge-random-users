//
//  Cache.swift
//  Random Users
//
//  Created by Joshua Sharp on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    // a place for items to be cached
    private var cache = [Key : Value]()
    // serial queue so that everyone can use shared resources without using NSLock
    private var queue = DispatchQueue(label: "info.emptybliss.randomusers.ConcurrentOperationStateQueue")
    
    // have a function to add items to the cache
    func cache(key: Key, value: Value) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    // have a function to returns items that are cache
    func value(key: Key) -> Value? {
        return queue.sync {
            cache[key]
        }
    }
}
