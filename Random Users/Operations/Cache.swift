//
//  Cache.swift
//  Random Users
//
//  Created by Diante Lewis-Jolley on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key: Hashable {

    private var cachedItems: [Key: Value] = [:]

    func cache(value: Value, for key: Key) {

        queue.async {
            self.cachedItems[key] = value
        }
    }

    func value(for key: Key) -> Value? {

        return queue.sync {
            cachedItems[key]
        }
    }

    private let queue = DispatchQueue(label: "com.DianteLewis.ThreadSafeSerialQueue")




}
