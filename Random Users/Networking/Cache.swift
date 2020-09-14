//
//  Cache.swift
//  Random Users
//
//  Created by Sammy Alvarado on 9/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var userImageCache: [Key: Value] = [:]

    let queue = DispatchQueue(label: "User thumbnail and fullsize image")

    func cache(value: Value , for key: Key) {
        queue.async {
            self.userImageCache[key] = value
        }
    }

    func getValue(for key: Key) -> Value? {
        queue.sync {
            return self.userImageCache[key]
        }
    }
}
