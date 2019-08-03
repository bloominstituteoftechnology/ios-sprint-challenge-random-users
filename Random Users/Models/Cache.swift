//
//  Cache.swift
//  Random Users
//
//  Created by Michael Stoffer on 8/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { cache[key] }
    }
    
    private var cache = [Key : Value]()
    private let queue = DispatchQueue(label: "com.LambdaSchool.RandomUsers.CacheQueue")
}
