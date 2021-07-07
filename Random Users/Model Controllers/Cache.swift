//
//  Cache.swift
//  Random Users
//
//  Created by Moses Robinson on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class Cache<Key: Hashable, Value> {
    
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
    
    private var cachedItems: [Key : Value] = [:]
    
    private let queue = DispatchQueue(label: "com.MosesRobinson.RandomUsers.CacheQueue")
}
