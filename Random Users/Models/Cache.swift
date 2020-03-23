//
//  Cache.swift
//  Random Users
//
//  Created by Joshua Rutkowski on 3/22/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value>{
    
    private var cache = [Key : Value]()
    private var queue = DispatchQueue(label: "CacheQueue")
    
    func cache(value: Value, key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { cache[key] }
    }
    
}
