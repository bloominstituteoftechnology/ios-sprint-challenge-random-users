//
//  Cache.swift
//  Random Users
//
//  Created by Stephanie Bowles on 8/15/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation



class Cache<Key: Hashable, Value> {
    private var cachedItems: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "Serial Queue")
    
    
    func cache(value: Value, for key: Key) {
        queue.sync {
            self.cachedItems[key] = value
        }
    }
    
    func value(key: Key) -> Value? {
        return queue.sync {
            self.cachedItems[key]
        }
    }
}
