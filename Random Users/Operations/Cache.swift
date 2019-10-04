//
//  Cache.swift
//  Random Users
//
//  Created by Jake Connerly on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<T: Hashable, Value> {
    
    private(set) var cachedItems: [T: Value] = [:]
    private let queue = DispatchQueue(label: "Serial Queue")
    
    func cache(value: Value, for key: T) {
        queue.async {
            self.cachedItems[key] = value
        }
    }
    
  
    func value(for key: T) -> Value? {
        queue.sync {
            guard let value = cachedItems[key] else { return nil }
            return value
        }
    }
}

