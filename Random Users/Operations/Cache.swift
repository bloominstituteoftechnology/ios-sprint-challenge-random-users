//
//  Cache.swift
//  Random Users
//
//  Created by Juan M Mariscal on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache <Key : Hashable, Value> {
        
    private var cacheImageDictionary: [Key : Value] = [:]

    func cache(value: Value, for key: Key) {
        cacheImageDictionary[key] = value
    }
    
    func value(for key: Key) -> Value? {
        return cacheImageDictionary[key]
    }
}
