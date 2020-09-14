//
//  Cache.swift
//  Random Users
//
//  Created by Zachary Thacker on 9/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    // MARK: - Properties
    
    private var storedCache: [Key : Value] = [:]
    private let queue = DispatchQueue(label: "Private Queue for Cache")
    
    // MARK: - Functions
    
    func storeInCache(value: Value, for key: Key) {
        queue.async {
            self.storedCache[key] = value
        }
    }
    
    func getValue(for key: Key) -> Value? {
        queue.sync {
            guard let storedValue = self.storedCache[key] else { return nil }
            return storedValue
        }
    }
}
