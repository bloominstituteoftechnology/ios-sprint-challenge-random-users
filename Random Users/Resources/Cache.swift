//
//  Cache.swift
//  Random Users
//
//  Created by Vuk Radosavljevic on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    
    private var items: [Key: Value] = [:]
    
    
    func cache(value: Value, forKey: Key) {
        queue.async {
            self.items[forKey] = value
        }
    }
    
    func value(forKey: Key) -> Value? {
        return queue.sync {
            items[forKey] ?? nil
        }
    }
    
    private let queue = DispatchQueue(label: "com.vukrado.queue")
    
}
