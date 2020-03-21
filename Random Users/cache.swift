//
//  cache.swift
//  Random Users
//
//  Created by denis cedeno on 3/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {

    private var cacheDictionary: [Key : Value] = [:]

    private var queue = DispatchQueue.init(label: "image.cache.queue")

    func cache(value: Value, for key: Key) {

        queue.async {
            self.cacheDictionary[key] = value
        }
        
    }
    
    func value(for key: Key) -> Value? {

        return queue.sync {
            cacheDictionary[key]
        }
    }
}

