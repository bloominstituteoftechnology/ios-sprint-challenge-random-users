//
//  Cache.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_268 on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


class Cache<Key: Hashable, Value> {
    private var dict: [Key: Value] = [:]
    private var queue = DispatchQueue(label: "Cache Queue")
    
    func cache(value: Value, for key: Key) {
        queue.sync {
            self.dict[key] = value
        }
    }
        func value(for key: Key) -> Value?  {
            queue.sync {
            return dict[key] ?? nil
            }
        }
        
    }

