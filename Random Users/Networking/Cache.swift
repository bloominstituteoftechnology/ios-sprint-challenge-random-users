//
//  Cache.swift
//  Random Users
//
//  Created by Victor  on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
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
}
