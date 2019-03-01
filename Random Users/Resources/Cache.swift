//
//  Cache.swift
//  Random Users
//
//  Created by Julian A. Fordyce on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class Cache<Key: Hashable, Value> {
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cachedItems[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync {
            cachedItems[key]
        }
    }
    
    private var cachedItems: [Key : Value] = [:]

    private let queue = DispatchQueue(label: "com.JulianFordyce.RandomUsers.CacheQueue")
}
