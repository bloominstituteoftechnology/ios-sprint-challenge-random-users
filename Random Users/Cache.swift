//
//  Cache.swift
//  Random Users
//
//  Created by Jorge Alvarez on 2/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class Cache<Key: Hashable, Value> {
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cache[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync { cache[key] }
    }
    
    private var cache = [Key : Value]()
    private let queue = DispatchQueue(label: "CacheQueue")
}
