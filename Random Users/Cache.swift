//
//  Cache.swift
//  Random Users
//
//  Created by Moin Uddin on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation


class Cache<Key, Value> where Key: Hashable {
    
    private(set) var cachedImages = [Key:Value]()
    
    private let queue = DispatchQueue(label: "com.moinuddin.RandomUsers.cacheQueue")
    
    func cache(value: Value?, for key: Key) {
        queue.async {
            self.cachedImages[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync {
            return self.cachedImages[key]
        }
    }
}
