//
//  Cache.swift
//  Random Users
//
//  Created by Thomas Sabino-Benowitz on 2/18/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation




class Cache<Key: Hashable , Value> {

  
    private var cacheSafe = [Key: Value]()
   
    private var queue = DispatchQueue(label: "CQ")

    
    func cache(value: Value, key: Key) {
        queue.async {
            self.cacheSafe[key] = value
        }
    }

    func value(key: Key) -> Value? {
        return queue.sync {
            cacheSafe[key]
        }
    }

}
