//
//  Cache.swift
//  Random Users
//
//  Created by Enayatullah Naseri on 1/24/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var cache: [Key : Value] = [:]
    private let queue = DispatchQueue(label: "com.catchQueue.randomPeople")
    
    func cache(value: Value, key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    func value(key: Key) -> Value? {
        return queue.sync { cache[key] }
    }
}
