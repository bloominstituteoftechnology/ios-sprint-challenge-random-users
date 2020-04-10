//
//  Cache.swift
//  Random Users
//
//  Created by Tobi Kuyoro on 10/04/2020.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private let cacheQueue = DispatchQueue(label: "CacheQueue")
    private var storedImages: [Key: Value] = [:]
    
    func cache(value: Value, for key: Key) {
        cacheQueue.async {
            self.storedImages[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        cacheQueue.sync {
            return storedImages[key]
        }
    }
}
