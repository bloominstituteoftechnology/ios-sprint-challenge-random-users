//
//  Cache.swift
//  Random Users
//
//  Created by Karen Rodriguez on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

// I'm assuming usingg generics and conforming Key to hashable makes it usable for any kind of pairing, but also safely.
class Cache<Key: Hashable, Value> {
    // Don't give access to the actual cache.
    private var cache: [Key : Value] = [ : ]
    // Don't give access to this queue. We wanna keep it for the cache.
    private var queue = DispatchQueue(label: "Cache serial queue")
    
    // So use methods to manage the properties. makes me feel like i'm using C++
    // SET
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    // GET
    func value(for key: Key) -> Value? {
        queue.sync {
            return self.cache[key]
        }
    }
    
}
