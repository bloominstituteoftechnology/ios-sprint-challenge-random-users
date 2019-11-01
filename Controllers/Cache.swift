//
//  Cache.swift
//  Random Users
//
//  Created by macbook on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var catchedImages: [Key : Value] = [:]
    private let queue = DispatchQueue(label: "MyQueue")
    
    
    func cache(value: Value, key: Key) {
        queue.async {
            self.catchedImages[key] = value
        }
    }
    
    func value(key: Key) -> Value? {
        return queue.sync {
            catchedImages[key]        }
    }
    
    
    
}
