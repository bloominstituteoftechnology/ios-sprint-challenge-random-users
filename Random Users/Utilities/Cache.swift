//
//  Cache.swift
//  Random Users
//
//  Created by scott harris on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private(set) var dictionary: [Key: Value] = [:]
    private var queue = DispatchQueue(label: "Contacts.Image.Cache")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.dictionary[key] = value
        }
        
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync {
            dictionary[key]
        }
        
    }
    
}
