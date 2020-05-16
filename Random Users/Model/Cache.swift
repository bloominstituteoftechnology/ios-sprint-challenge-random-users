//
//  Cache.swift
//  Random Users
//
//  Created by Elizabeth Thomas on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var dictionary: [Key : Value] = [:]
    
    private let queue = DispatchQueue(label: "photoQueue")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.dictionary[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        queue.sync {
            return dictionary[key]
        }
    }
    
}
