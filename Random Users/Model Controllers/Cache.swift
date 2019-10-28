//
//  Cache.swift
//  Random Users
//
//  Created by Lisa Sampson on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key: Hashable {
    
    // MARK: - Properties
    private var cachedUsers: [Key : Value] = [:]
    private let queue = DispatchQueue(label: "com.LisaSampson.RandomeUsers.CacheQueue")
    
    // MARK: - Methods
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cachedUsers[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync {
            return cachedUsers[key]
        }
    }
}
