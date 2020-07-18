//
//  Cache.swift
//  Random Users
//
//  Created by Clayton Watkins on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value>{
    
    // MARK: - Properties
    private var storedCache: [Key : Value] = [:]
    private let queue = DispatchQueue(label: "Private Queue for Cache")
    
    // MARK: - Functions
    // Save values to our Cache
    func storeInCache(value: Value, for key: Key){
        queue.async {
            self.storedCache[key] = value
        }
    }
    
    // Retrieve values from our cache from a corresponding key
    func getValue(for key: Key) -> Value?{
        queue.sync {
            guard let storedValue = self.storedCache[key] else { return nil}
            return storedValue
        }
    }
}
