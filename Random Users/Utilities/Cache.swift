//
//  Cache.swift
//  Random Users
//
//  Created by Ilgar Ilyasov on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class Cache <Key: Hashable, Value> {
    
    // Create a queue especially for Cache.
    // So it makes Cache thread-safe to be shared between two different threads
    let queue = DispatchQueue(label: "com.ilqarilyasov.randomUsers.searialCacheQueue")
    private var cacheItems: [Key: Value] = [:]
    
    // Add new pair
    func cache(value: Value?, forKey: Key) {
        queue.async { self.cacheItems[forKey] = value }
    }
    
    // Return the value
    func value(forKey: Key) -> Value? {
        return queue.sync { self.cacheItems[forKey] }
    }
    
}



