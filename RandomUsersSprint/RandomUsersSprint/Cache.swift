//
//  Cache.swift
//  RandomUsersSprint
//
//  Created by Luqmaan Khan on 9/6/19.
//  Copyright © 2019 Luqmaan Khan. All rights reserved.
//

import Foundation

class Cache<Key: Hashable,Value> {
    private var cacheStore: [Key:Value] = [:]
    var queue = DispatchQueue(label: "Serial Queue")
    func cache(value:Value , for key: Key) {
        queue.sync {
            cacheStore.updateValue(value, forKey: key)
        }
    }
    func value(for key: Key) -> Value? {
        return queue.sync {
            cacheStore[key]
        }
    }
}
