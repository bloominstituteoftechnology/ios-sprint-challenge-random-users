//
//  Cache.swift
//  Random Users
//
//  Created by Benjamin Hakes on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var items: [Key: Value] = [:]
    private var queue = DispatchQueue(label: "com.benhakes.ThreadSafeCache")
    
    // Add + Remove Update
    func cache(value: Value, for key: Key){
        queue.async { self.items[key] = value }
    }
    
    func value(for key: Key) -> Value?{
        return queue.sync { items[key] }
    }
    
}
