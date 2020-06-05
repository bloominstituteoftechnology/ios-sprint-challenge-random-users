//
//  Cache.swift
//  Random Users
//
//  Created by Harmony Radley on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {

    private var dictionary = [Key: Value]()
    private var queue = DispatchQueue(label: "CacheQueue")

    // Adding the keys to the dictionary
    func cache(key: Key, value: Value){
        queue.async {
            self.dictionary[key] = value
        }
    }

    // Returning the value
    func value(key: Key) -> Value? {
        return queue.sync {
            dictionary[key] ?? nil
        }
    }
}
