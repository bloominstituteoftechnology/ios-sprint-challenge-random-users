//
//  Cache.swift
//  Random Users
//
//  Created by Moses Robinson on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class Cache<Key, Value> where Key: Hashable {
    
    let queue = DispatchQueue(label: "com.MosesRobinson.Queue")
    var cachedUsers: [Key : Value] = [:]
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cachedUsers[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync {
            return cachedUsers[key]
        }
    }
}
