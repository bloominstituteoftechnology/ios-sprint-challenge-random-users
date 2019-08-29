//
//  Cache.swift
//  Random Users
//
//  Created by Sameera Roussi on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key: Hashable {
    
    // MARK: - Cache
    func cache(value: Value, for key: Key) {
        serialQueue.async {
            self.cachedUsers[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return serialQueue.sync {
            return cachedUsers[key]
        }
    }
    
    // MARK: - Properties
    private let serialQueue = DispatchQueue(label: "SameeraLeola.ThreadSafeQueue")
    private var cachedUsers: [Key : Value] = [:]
}
