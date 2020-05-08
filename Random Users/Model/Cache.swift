//
//  Cache.swift
//  Random Users
//
//  Created by Mark Poggi on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


class Cache<Key: Hashable, Value> {

    // set up the cache
    private var cache = [Key : Value]()

    // created a serial queue
    private var queue = DispatchQueue(label: "Placeholder")

    // add items to the cache of type dictionary
    func cache(key: Key, value: Value) {
        queue.async {
            self.cache[key] = value
        }
    }

    // return items from the cache of type dictionary
    func value(key: Key) -> Value? {
        // Making this sync rather than async.  Needs to work with other threads.
        return queue.sync {
            cache[key]
        }
    }



}
