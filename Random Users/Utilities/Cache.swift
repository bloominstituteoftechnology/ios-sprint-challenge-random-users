//
//  Cache.swift
//  Random Users
//
//  Created by Christopher Aronson on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var cache: [Key : Value] = [:]
    private var queue = DispatchQueue(label: "cacheQueue", qos: .background)
    
    func cache(value: Value, for key: Key) {
        queue.sync {
            _ = cache.updateValue(value, forKey: key)
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { () -> Value? in
            guard let value = cache[key] else { return nil }
            
            return value
        }
    }
}
