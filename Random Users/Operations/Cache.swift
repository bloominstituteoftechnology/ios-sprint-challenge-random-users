//
//  Cache.swift
//  Random Users
//
//  Created by Jason Modisett on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key: Hashable {
    
    // MARK:- Caching methods
    func cache(value: Value, for key: Key) {
        queue.async { self.cachedItems[key] = value }
    }
    
    // Returns the cached item for the given key
    func value(for key: Key) -> Value? {
        return queue.sync { cachedItems[key] }
    }
    
    // MARK:- Properties & types
    private var cachedItems: [Key: Value] = [:]
    private var queue = DispatchQueue(label: "com.LambdaSchool.RandomUsers.Cache")
}
