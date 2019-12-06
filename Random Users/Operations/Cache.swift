//
//  Cache.swift
//  Random Users
//
//  Created by Niranjan Kumar on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

// Hashable allows two different things to be tied together in a dictionary (a key <> value pair)
class Cache<Key: Hashable , Value> {
    
    // a place for items to be cached
    private var cacheStore = [Key: Value]()
    // serial queue so that everyoen can use shared resources without using NSLock
    private var queue = DispatchQueue(label: "CacheQueue")
    
    // have a function to add items to the cache
    func cache(key: Key, value: Value) {
        queue.async {
            self.cacheStore[key] = value
        }
    }
    
    // have a function to return items that are cache
    func value(key: Key) -> Value? {
        return queue.sync {
            cacheStore[key]
        }
    }
    
}
