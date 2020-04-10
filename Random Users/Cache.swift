//
//  Cache.swift
//  Random Users
//
//  Created by Mark Gerrior on 4/10/20.
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
