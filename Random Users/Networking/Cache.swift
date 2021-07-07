//
//  Cache.swift
//  Random Users
//
//  Created by Paul Yi on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key: Hashable {
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cachedUsers[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync {
            return cachedUsers[key]
        }
    }
    
    private var cachedUsers = [Key: Value]()
    private let queue = DispatchQueue(label: "com.PaulYi.ThreadSafeSerialQueue")
}
