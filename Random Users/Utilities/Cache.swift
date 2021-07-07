//
//  Cache.swift
//  Random Users
//
//  Created by Scott Bennett on 10/12/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key: Hashable {
    
    private var cachedItems: [Key: Value] = [:]
    private var queue = DispatchQueue(label: "com.LambdaSchool.RandomUsers.cacheQueue")
    
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
}
