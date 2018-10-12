//
//  Cache.swift
//  Random Users
//
//  Created by Scott Bennett on 10/12/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import Foundation

struct Cache<Key: Hashable, Value> {
    
    var queue = DispatchQueue(label: "com.scott.Cache.SyncQueue")
    var items:[Key: Value] = [:]
    
    func retrieve(_ key: Key) -> Value? {
        return queue.sync{
            items[key]
        }
    }
    
    mutating func store(_ key: Key, _ value: Value) {
        queue.sync {
            items[key] = value
        }
    }
}
