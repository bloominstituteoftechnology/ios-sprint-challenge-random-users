//
//  Cache.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {

    private var dictionary = [Key: Value]()
    private var queue = DispatchQueue(label: "Cache Queue")

    func cache(value: Value, for key: Key){
        queue.async {
            self.dictionary[key] = value
        }
    }

    func value(for key: Key) -> Value? {
        return queue.sync {
            dictionary[key] ?? nil
        }

    }
}
