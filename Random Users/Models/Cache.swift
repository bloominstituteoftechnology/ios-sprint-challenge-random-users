//
//  Cache.swift
//  Random Users
//
//  Created by Cody Morley on 6/6/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var storedCache: [Key : Value] = [:]
    private var queue = DispatchQueue(label: "com.CodyMorley.RandomUsers.CacheQueue")
    
    func cache(for key: Key ,value: Value) {
        queue.async {
            self.storedCache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync {
            storedCache[key]
        }
    }
    
    
}
