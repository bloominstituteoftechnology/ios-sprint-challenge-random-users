//
//  Cache.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 2/1/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var cachedContacts: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "ng.sugabelly.Random-Users.cacheQueue")
    
    func saveToCache(value: Value?, for key: Key) {
        queue.async { self.cachedUsers[key] = value }
    }
    
    func getValue(for key: Key) -> Value? {
        return queue.sync { cachedUsers[key] }
    }
}
