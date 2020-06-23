//
//  Cache.swift
//  Random Users
//
//  Created by Waseem Idelbi on 6/22/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    /// Stores cached items, initialized with an empty dictionary
    private var dictionary: [Key : Value] = [ : ]
    
    private let queue = DispatchQueue(label: "Serial Queue")
    
    /// Adds items to cache (setting of value occurs on the queue)
    func cache(value: Value, for key: Key) {
        queue.async {
            self.dictionary[key] = value
        }
    }
    
    /// Returns associated value from cache
    func value(for key: Key) -> Value? {
        queue.sync {
            return dictionary[key]
        }
    }
}
