//
//  UserCache.swift
//  Random Users
//
//  Created by Jerrick Warren on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

// Generic Cache Class

class Cache<Key, Value> where Key: Hashable {
    public func cache(value: Value, for key: Key) {
        queue.async {
            self.cachedItems[key] = value
        }
    }
    
    public func value(for key: Key) -> Value? {
        return queue.sync {
            cachedItems[key]
        }
    }
    
    private var cachedItems: [Key: Value] = [:]
    private var queue = DispatchQueue(label: "com.JerrickWarren.randomUsers.cacheQueue")
}
