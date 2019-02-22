//
//  Cache.swift
//  Random Users
//
//  Created by Nelson Gonzalez on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
class Cache<Key: Hashable, Value> {
    
    // Create a queue especially for Cache.
    // So it makes Cache thread-safe to be shared between two different threads
    
    private var cache = [Key : Value]()
    private let queue = DispatchQueue(label: "com.NelsonGonzalez.RandomUsers.imageCache")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { cache[key] }
    }
    
    func clear() {
        queue.async {
            self.cache.removeAll()
        }
    }
    
}
