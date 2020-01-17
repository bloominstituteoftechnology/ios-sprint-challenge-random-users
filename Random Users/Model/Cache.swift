//
//  Cache.swift
//  Random Users
//
//  Created by Rick Wolter on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    // Serial queue so everyone can use shared resources without using NSLock
    private let queue = DispatchQueue(label: "RandomUsers Cache queue")
    // A place for items to be cached
       private var cache = [Key: Value]()
    
    
     // function to add items to the cache
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    //  function returns cache items
    func value(for key: Key) -> Value? {
       return queue.sync {
            cache[key]
        }
    }
}

