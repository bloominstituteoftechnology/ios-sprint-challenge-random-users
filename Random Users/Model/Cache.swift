//
//  Cache.swift
//  Random Users
//
//  Created by Michael on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var thumbnailDictionary: [Key : Value] = [:]
    
    private var largeDictionary: [Key : Value] = [:]
     
    private let queue = DispatchQueue(label: "Serial Queue")
    
    func thumbnailCache(value: Value, for key: Key) {
        queue.async {
            return self.thumbnailDictionary[key] = value
        }
    }
    
    func thumbnailValue(for key: Key) -> Value? {
        queue.sync {
            return thumbnailDictionary[key]
        }
    }
    
    func largeCache(value: Value, for key: Key) {
        queue.async {
            return self.largeDictionary[key] = value
        }
    }
    
    func largeValue(for key: Key) -> Value? {
        queue.sync {
            return largeDictionary[key]
        }
    }
}
