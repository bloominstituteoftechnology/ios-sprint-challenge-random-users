//
//  Cache.swift
//  Random Users
//
//  Created by Dahna on 6/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


class Cache<Key: Hashable, Value> {
    
    private let queue = DispatchQueue(label: "UsersCacheQueue")
    
    private var dict = [Key: Value]()
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.dict[key] = value
        }
    }
    func value(for key: Key) -> Value? {
        return queue.sync {
            dict[key]
        }
    }
}
