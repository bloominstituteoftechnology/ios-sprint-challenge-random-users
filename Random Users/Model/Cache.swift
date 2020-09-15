//
//  Cache.swift
//  Random Users
//
//  Created by Craig Belinfante on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    let q = DispatchQueue(label: "Cached Queue")
    
    var cachedImage: [Key:Value] = [:]
    
    func cache(value: Value, forKey: Key) {
            q.async {
            self.cachedImage[forKey] = value
        }
    }
    
    func value(forKey: Key) -> Value? {
        q.sync {
            return cachedImage[forKey]
        }
    }
    
}
