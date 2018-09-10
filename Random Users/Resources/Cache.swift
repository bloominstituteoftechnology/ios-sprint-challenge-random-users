//
//  Cache.swift
//  Random Users
//
//  Created by Andrew Liao on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key: Hashable{
    func cache(value: Value, for key: Key){
        queue.async {
            self.cacheStore[key] = value
        }
    }
    func value(for key: Key) -> Value?{
        
        return queue.sync {
            cacheStore[key]
        }
        
    }

    //MARK: - Properties
    private var cacheStore: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "com.Andrew.CacheQueue")
    
}
