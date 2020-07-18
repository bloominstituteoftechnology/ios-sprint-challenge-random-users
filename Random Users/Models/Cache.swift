//
//  Cache.swift
//  Random Users
//
//  Created by Bronson Mullens on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    // MARK: - Properties
    private var storedCache: [Key : Value] = [:]
    private let queue = DispatchQueue(label: "Cache Queue")
    
    // MARK: - Cache Functions
    func sendToCache(value: Value, key: Key) {
        queue.async {
            self.storedCache[key] = value
        }
    }
    
    func getValue(key: Key) -> Value? {
        queue.sync {
            guard let storedValue = self.storedCache[key] else { return nil }
            return storedValue
        }
    }
    
}
