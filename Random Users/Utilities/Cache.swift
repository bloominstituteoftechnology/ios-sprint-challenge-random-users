//
//  Cache.swift
//  Random Users
//
//  Created by Chad Rutherford on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var dict = [Key : Value]()
    private let queue = DispatchQueue(label: "CacheQueue")
    
    func cache(value: Value, for key: Key) {
        queue.sync {
            dict[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        queue.sync {
            return dict[key]
        }
    }
    
    func contains(_ key: Key) -> Bool {
        queue.sync {
            return dict.keys.contains(key)
        }
    }
}
