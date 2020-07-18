//
//  Cache.swift
//  Random Users
//
//  Created by Morgan Smith on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache <Key: Hashable, Value> {

   private let queue = DispatchQueue(label: "cacheQueue")
    private var cache : [Key: Value] = [:]

    func cache(value: Value, for key: Key) {
        queue.sync {
            if let _ = cache[key] { return }
            cache[key] = value
        }
    }

    func value(for key: Key) -> Value?{
        return queue.sync { cache[key] }
    }

}
