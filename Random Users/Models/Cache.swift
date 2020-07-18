//
//  Cache.swift
//  Random Users
//
//  Created by Rob Vance on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var cacheDictionary: [Key : Value] = [:]
    private let queue = DispatchQueue(label: "com.LambdaSchool.RandomUsers.CacheQueue")
    
    func cache(key: Key, value: Value) {
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

