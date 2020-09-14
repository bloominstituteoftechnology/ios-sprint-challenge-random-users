//
//  Cache.swift
//  Random Users
//
//  Created by Gladymir Philippe on 9/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache <Key : Hashable, Value> {
    
    private var cacheImageDirectory: [Key : Value] = [:]
    
    func cache(value: Value, for key: Key) {
        cacheImageDirectory[key] = value
    }
    
    func value(for key: Key) -> Value? {
        return cacheImageDirectory[key]
    }
}
