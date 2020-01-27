//
//  Cache.swift
//  Random Users
//
//  Created by Craig Swanson on 1/26/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Friend> {
    
    private var cacheDictionary: [Key: Friend] = [:]
    let backgroundQueue = DispatchQueue(label: "Cache Serial Queue")
    
    func cache(value: Friend, key: Key) {
        backgroundQueue.async {
            self.cacheDictionary.updateValue(value, forKey: key)
        }
    }
    
    func value(for key: Key) -> Friend? {
        return backgroundQueue.sync { () -> Friend? in
            return cacheDictionary[key] ?? nil
        }
    }
}
