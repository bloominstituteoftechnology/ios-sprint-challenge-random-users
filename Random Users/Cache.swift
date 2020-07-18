//
//  Model.swift
//  Random Users
//
//  Created by Bohdan Tkachenko on 7/18/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var dictionary: [Key : Value] = [ : ]
    private let queue = DispatchQueue(label: "Safe Thread")
    
    func cache(value: Value?, for theKey: Key) {
        queue.async {
            self.dictionary[theKey] = value
        }
    }
    
    func value(for theKey: Key) -> Value? {
        queue.sync {
            return dictionary[theKey]
        }
    }
    
}
