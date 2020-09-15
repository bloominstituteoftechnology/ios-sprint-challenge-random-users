//
//  Cache.swift
//  Random Users
//
//  Created by John McCants on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    var dict : [Key: Value] = [:]
    
    let queue = DispatchQueue(label: "Cache")
    
    func setValue(value: Value, key: Key )  {
        queue.async {
            self.dict[key] = value
        }
    }
    
    func getValue(key: Key) -> Value? {
        queue.sync {
            return self.dict[key]
        }
    }
    
    func remove() {
        queue.async {
            self.dict.removeAll()
        }
    }
}
