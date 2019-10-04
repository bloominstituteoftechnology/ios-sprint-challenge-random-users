//
//  Cache.swift
//  Random Users
//
//  Created by brian vilchez on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
   
    private(set) var cachedData: [Key: Value] = [:]
    private(set) var queue = DispatchQueue(label: "Users.cachedData")
    
    func cacheData(key: Key, value: Value) {
        queue.async {
            self.cachedData[key] = value
        }
        
        func data(key: Key) -> Value? {
            return queue.sync {
                cachedData[key]
            }
            
        }
    }
}

