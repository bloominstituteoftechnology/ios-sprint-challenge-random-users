//
//  Cache.swift
//  Random Users
//
//  Created by Nick Nguyen on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key:Hashable,Value> {
    
    private let queue = DispatchQueue(label: "com.RandomUsers.Nick.SerialQueue")
    
    private var storage: [Key:Value] = [:]
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.storage[key] = value
        }
        
    }
    
    func value(for key: Key) -> Value? {
        queue.sync {
            return self.storage[key]
        }
    }
    
    
}
