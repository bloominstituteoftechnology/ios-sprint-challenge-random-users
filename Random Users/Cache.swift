//
//  Cache.swift
//  Random Users
//
//  Created by Bhawnish Kumar on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var queue = DispatchQueue(label: "MyCacheQueue")
    
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
