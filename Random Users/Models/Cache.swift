//
//  Cache.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_204 on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value>{
    
    // MARK: - Properties
    
    private var cache = [Key : Value]()
    private var queue = DispatchQueue(label: "CacheQueue")
    
    
    // MARK: - Methods
    
    func cache(value: Value, key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { cache[key] }
    }
    
}
