//
//  Cache.swift
//  Random Users
//
//  Created by Gerardo Hernandez on 4/4/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var dictionary: [Key : Value] = [:]
    
    private let queue = DispatchQueue(label: "DicictionaryQueueCache")
    
    func cache(value: Value, for key: Key) {
        queue.async{
            self.dictionary[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync {
            return dictionary[key]
        }
    }
}
