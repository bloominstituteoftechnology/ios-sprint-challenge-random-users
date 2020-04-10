//
//  Cache.swift
//  Random Users
//
//  Created by Wyatt Harrell on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var queue = DispatchQueue(label: "Cache Queue")
    
    var dict: [Key : Value] = [:]
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.dict[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        queue.sync {
            return dict[key] ?? nil
        }
    }
}
