//
//  Cache.swift
//  Random Users
//
//  Created by Christy Hicks on 1/26/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    // MARK: Properties
    private var cachedItems: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "com.LambdaSchool.RandomUsers.CacheQueue")
    
    // MARK: Methods
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
