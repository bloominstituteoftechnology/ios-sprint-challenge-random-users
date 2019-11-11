//
//  Cache.swift
//  Random Users
//
//  Created by Fabiola S on 11/8/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var cachedItems: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "com.LambdaSchool.RandomUsers.CacheQueue")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cachedItems[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync {
            cachedItems[key]
        }
    }
}
