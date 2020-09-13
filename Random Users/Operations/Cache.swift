//
//  Cache.swift
//  Random Users
//
//  Created by Gladymir Philippe on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var dict: [Key: Value] = [:]
    private var queue = DispatchQueue(label: "Cache Queue")

    func cache(value: Value, for: Key) {
        queue.async {
            self.dict[`for`] = value
        }
    }

    func value(for: Key) -> Value? {
        queue.sync {
            return dict[`for`]
        }
    }
}


//class Cache<Key: Hashable, Value> {
//
//    private var storedCache: [Key : Value] = [:]
//    private let queue = DispatchQueue(label: "Private Queue for Cache")
//
//    func storeInCache(value: Value, for key: Key) {
//        queue.async {
//            self.storedCache[key] = value
//        }
//    }
//
//    func getValue(for key: Key) -> Value? {
//        queue.sync {
//            guard let storedValue = self.storedCache[key] else { return nil}
//            return storedValue
//        }
//    }
//}
