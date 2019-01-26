//
//  Cache.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var cachedUsers: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "io.lotanna.randomUsers.cacheQueue")
    
    func cache(value: Value?, for key: Key) {
        queue.async { self.cachedUsers[key] = value }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { cachedUsers[key] }
    }
}
