//
//  Cache.swift
//  Random Users
//
//  Created by Seschwan on 8/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var cacheDictionary = [Key : Value]()
    
    private let q = DispatchQueue(label: "PrivateDispatchQ")
    
    func cache(value: Value, key: Key) {
        q.async {
            self.cacheDictionary[key] = value
        }
    }
    
    func returnValue(key: Key) -> Value? {
       return q.sync {
            cacheDictionary[key]
        }
    }
}
