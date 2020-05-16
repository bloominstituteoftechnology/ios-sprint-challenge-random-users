//
//  Cache.swift
//  Random Users
//
//  Created by patelpra on 5/16/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class Cache<Key: Hashable, Value> {
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { cache[key] }
    }
    
    private var cache = [Key : Value]()
    private let queue = DispatchQueue(label: "com.LambdaSchool.Astronomy.CacheQueue")
}
