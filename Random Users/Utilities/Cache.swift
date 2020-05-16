//
//  Cache.swift
//  Random Users
//
//  Created by Chad Parker on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var items: [Key: Value] = [:]
    private let queue: DispatchQueue = .init(label: "com.chadparker.lambda.randomusers")
    
    func cache(value: Value, for key: Key) {
        queue.sync {
            items[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        queue.sync {
            items[key]
        }
    }
}
