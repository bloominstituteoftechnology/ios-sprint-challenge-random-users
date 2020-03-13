//
//  Cache.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_268 on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


class Cache<Key: Hashable, Value> {
    private var cache: [Key: Value] = [:]
    private var queue = DispatchQueue(label: "Cache Queue")
    
    func cache(value: Value, for key: Key) {
        queue.sync {
            self.cache[key] = value
        }
    }
        func value(for key: Key) -> Value?  {
            queue.sync {
            return cache[key] ?? nil
            }
        }
        
    }

