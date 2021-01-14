//
//  Cache.swift
//  Random Users
//
//  Created by Sammy Alvarado on 9/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {

    private var imageCache: [Key: Value] = [:]

    
    let queue = DispatchQueue(label: "QueueItem")

    func cache(value: Value , for key: Key) {
        queue.async {
            self.imageCache.updateValue(value, forKey: key)
        }
    }

    func getValue(for key: Key) -> Value? {
        queue.sync {
            return self.imageCache[key]
        }
    }
}
