//
//  Cache.swift
//  Random Users
//
//  Created by morse on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable , Value> {
    private var cachedItems: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "User.ConcurrentOperationStateQueue")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cachedItems[key] = value
        }
    }
    
    func retrieveValue(for key: Key) -> Value? {
        
        queue.sync {
            if let item = cachedItems[key] {
                return item
            } else {
                return nil
            }
        }
    }
}
