//
//  Cache.swift
//  Random Users
//
//  Created by Marc Jacques on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    var cacheStorage = [Key : Value]()
    let dispatchQueue = DispatchQueue(label: "com.LambdaSchool.RandomUsers.CacheQueue")
    
    func cache(value: Value, for key: Key) {
        dispatchQueue.async {
            self.cacheStorage[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return dispatchQueue.sync { cacheStorage[key] }
    }
}
