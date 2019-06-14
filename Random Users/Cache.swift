//
//  Cache.swift
//  Random Users
//
//  Created by Jonathan Ferrer on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {

    private var store: [Key: Value] = [:]

    let queue = DispatchQueue(label: "com.LambdaSchool.RandomUsers.CacheQueue")

    func cache(value: Value, for key: Key) {
        queue.async {
            self.store[key] = value
        }
    }

    func value(for key: Key) -> Value? {
        return queue.sync {
            store[key]
        }
    }
}

