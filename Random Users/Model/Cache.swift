//
//  Cache.swift
//  Random Users
//
//  Created by John Kouris on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var cachedDictionary: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "PersonPhotoCacheQueue")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cachedDictionary[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        queue.sync {
            guard let value = cachedDictionary[key] else { return nil }
            return value
        }
    }
}
