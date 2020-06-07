//
//  Cache.swift
//  Random Users
//
//  Created by Vincent Hoang on 6/6/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var dict: [Key : Value] = [:]
    private let cacheQueue = DispatchQueue(label: "cacheQueue")
    
    func cache(for key: Key, value: Value) {
        cacheQueue.async {
            self.dict[key] = value
        }
    }
    
    func getValue(for key: Key) -> Value? {
        cacheQueue.sync {
            return self.dict[key]
        }
    }
}
