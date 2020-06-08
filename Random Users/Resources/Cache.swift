//
//  Cache.swift
//  Random Users
//
//  Created by Thomas Sabino-Benowitz on 2/18/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


// Hashable allows two different things to be tied together in a dictionary (a key <> value pair)


class Cache<Key: Hashable , Value> {

  
    private var cacheSafe = [Key: Value]()
   
    private var queue = DispatchQueue(label: "CQ")

    // have a function to add items to the cache
    func cache(value: Value, key: Key) {
        queue.async {
            self.cacheSafe[key] = value
        }
    }

    // have a function to return items that are cache
    func value(key: Key) -> Value? {
        return queue.sync {
            cacheSafe[key]
        }
    }

}
