//
//  Cache.swift
//  Random Users
//
//  Created by ronald huston jr on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    //  set up the cache with our generic
    private var cache = [Key : Value]()
    
    //  create a serial queue
    private var queue = DispatchQueue(label: "")
    
    //  add items to the cache dictionary
    func cache(key: Key, value: Value) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    //  return items from the cache
    func value(key: Key) -> Value? {
        //  want queue to be sync
        return queue.sync {
            cache[key]
        }
    }
}
