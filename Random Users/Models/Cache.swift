//
//  Cache.swift
//  Random Users
//
//  Created by Matthew Martindale on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var cacheDictionary: [Key : Value] = [:]
    private let queue = DispatchQueue(label: "serialQueue")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cacheDictionary[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        queue.sync {
            return self.cacheDictionary[key]
        }
    }
}
