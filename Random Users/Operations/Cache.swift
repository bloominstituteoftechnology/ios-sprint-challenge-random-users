//
//  Cache.swift
//  Random Users
//
//  Created by Carolyn Lea on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key: Hashable {
    
    private var dictionary: [Key:Value] = [:]
    private var queue: DispatchQueue = DispatchQueue(label: "com.leastudios.queue.cache")
    
    func cache(for key: Key, with value: Value) {
        queue.sync {
            dictionary[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        var value: Value?
        queue.sync {
            for item in dictionary {
                if item.key == key {
                    value = item.value
                }
            }
        }
        if let value = value { return value } else { return nil }
    }
    
}
