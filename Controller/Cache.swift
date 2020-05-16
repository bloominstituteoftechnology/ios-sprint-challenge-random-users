//
//  Cache.swift
//  Random Users
//
//  Created by Claudia Contreras on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache <Key: Hashable, Value> {
    private var cacheDictionary: [Key: Value] = [:]
    
    private let queue = DispatchQueue(label: "Cache Queue")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cacheDictionary[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        queue.sync {
            return cacheDictionary[key]
        }
    }
}
