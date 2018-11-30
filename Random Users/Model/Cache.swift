//
//  Cache.swift
//  Random Users
//
//  Created by Nikita Thomas on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class Cache<Key: Hashable, Value> {
    
    private var queue = DispatchQueue(label: "com.NikitaThomas.RandomUsers.CacheQueue")
    private var cacheDict: [Key: Value] = [:]
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cacheDict[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        var value: Value?
        queue.sync {
            value = cacheDict[key]
        }
        return value
    }
    
}
