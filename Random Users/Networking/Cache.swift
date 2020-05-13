//
//  Cache.swift
//  Random Users
//
//  Created by De MicheliStefano on 07.09.18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key: Hashable {
    
    private var store: [Key:Value] = [:]
    private var queue: DispatchQueue = DispatchQueue(label: "com.stefano.user.cache")
    
    func cache(for key: Key, with value: Value) {
        queue.sync {
            store[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        var value: Value?
        queue.sync {
            for item in store {
                if item.key == key {
                    value = item.value
                }
            }
        }
        if let value = value { return value } else { return nil }
    }
    
}
