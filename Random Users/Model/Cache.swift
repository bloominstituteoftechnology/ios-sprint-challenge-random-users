//
//  Cache.swift
//  Random Users
//
//  Created by Elizabeth Thomas on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var images: [Key : Value] = [:]
    
    private let cacheQueue = DispatchQueue(label: "photoQueue")
    
    func cache(value: Value, for key: Key) {
        cacheQueue.async {
            self.images[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return cacheQueue.sync { images[key] }
    }
    
}
