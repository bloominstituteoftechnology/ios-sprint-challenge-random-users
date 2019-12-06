//
//  Cache.swift
//  Random Users
//
//  Created by brian vilchez on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    // place for items to be cached
    private var cache = [Key: Value]()
    // serial queue so that everyone can use shared resources with out nslock
    private var queue = DispatchQueue(label: "com.LambdaSchool.RandomUsers.ConcurrentOperationStateQueue")
    
    // function for caching items
    func cache(value: Value, forKey key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    // returning items that are cached
    func value(forKey key: Key) -> Value? {
        return queue.sync {
            self.cache[key]
        }
    }
}
