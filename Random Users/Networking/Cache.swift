//
//  Cache.swift
//  Random Users
//
//  Created by Lydia Zhang on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
class Cache<Key: Hashable, Value> {
    
    private var dic: [Key : Value] = [:]
    private var queue = DispatchQueue(label: "Cache thread save queue")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.dic[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync {
            dic[key]
        }
    }
}
