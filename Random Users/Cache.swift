//
//  Cache.swift
//  Random Users
//
//  Created by Ufuk Türközü on 13.03.20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private let queue = DispatchQueue(label: "CacheQueue")
    private var cache: [Key: Value] = [ : ]
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        queue.sync {
            return self.cache[key]
        }
    }
}
