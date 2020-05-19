//
//  Cache.swift
//  Random Users
//
//  Created by Marc Jacques on 5/17/20.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var cache = [Key : Value]()
    
    private var queue = DispatchQueue(label: "CacheQueue")
        
    func add(value: Value, key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    
    func value(key: Key) -> Value? {
        return queue.sync {
            cache[key]
        }
    }
}
