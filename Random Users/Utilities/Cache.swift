//
//  Cache.swift
//  Random Users
//
//  Created by Chad Rutherford on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    private var dict = [Key : Value]()
    private let queue = DispatchQueue(label: "CacheQueue")
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Cache Value Creation
    func cache(value: Value, for key: Key) {
        queue.sync {
            dict[key] = value
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Cache Value Retrieval
    func value(for key: Key) -> Value? {
        queue.sync {
            return dict[key]
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: -  Cache checking
    func contains(_ key: Key) -> Bool {
        queue.sync {
            return dict.keys.contains(key)
        }
    }
}
