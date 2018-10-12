//
//  Cache.swift
//  Random Users
//
//  Created by Dillon McElhinney on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var cachedItems: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "com.dillonMcelhinney.randomUsers.cacheQueue")
    
    func cache(value: Value?, for key: Key) {
        queue.async { self.cachedItems[key] = value }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { cachedItems[key] }
    }
}
