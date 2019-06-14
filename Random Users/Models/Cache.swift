//
//  Cache.swift
//  Random Users
//
//  Created by Kobe McKee on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var cache: [Key : Value] = [:]
    private let queue = DispatchQueue(label: "RandomUserCacheQueue")
    
    func cache(value: Value, key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }

    func value(key: Key) -> Value? {
        return queue.sync { cache[key] }
    }
    
}
