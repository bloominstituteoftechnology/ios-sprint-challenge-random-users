//
//  Cache.swift
//  Random Users
//
//  Created by Shawn James on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    var dict: [Key : Value] = [:]
    private var queue = DispatchQueue(label: "Cache Queue")
    
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
