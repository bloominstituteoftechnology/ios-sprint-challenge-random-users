//
//  Cache.swift
//  Random Users
//
//  Created by Austin Potts on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
class Cache<Key: Hashable, Value> {
    
    private var cachedItems = [Key: Value]()
    private let queue = DispatchQueue(label: "CacheQueue")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cachedItems.updateValue(value, forKey: key)
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { cachedItems[key] }
    }
}
