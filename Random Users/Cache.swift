//
//  Cache.swift
//  Random Users
//
//  Created by Samantha Gatt on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key: Hashable {
    private var queue = DispatchQueue(label: "com.SamanthaGatt.RandomUsers.CacheSerialQueue")
    private var cachedItems: [Key: Value] = [:]
    
    subscript(_ key: Key) -> Value? {
        get {
            return queue.sync { cachedItems[key] ?? nil }
        }
    }
    
    func cache(value: Value, for key: Key) {
        queue.async { self.cachedItems[key] = value }
    }
}
