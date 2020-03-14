//
//  Cache.swift
//  Astronomy
//
//  Created by Linh Bouniol on 9/6/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class Cache<Key, Value> where Key: Hashable {
    
    // Dictionary that stores cached items
    private var cachedItems: [Key : Value] = [:]
    
    private let queue = DispatchQueue(label: "com.LambdaSchool.RandomUsers.SerialQueue")
    
    subscript(_ key: Key) -> Value? {
        return value(for: key)
    }
    
    func cache(value: Value, for key: Key) {
        // Add items to cache
        queue.async {
            self.cachedItems[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
//
        var returnValue: Value?

        // If this is async, it might try to return on line 38, before we have a value
        queue.sync {
            returnValue = self.cachedItems[key]
        }

        return returnValue
    }
}
