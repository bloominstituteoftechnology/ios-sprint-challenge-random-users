//
//  Cache.swift
//  Random Users
//
//  Created by Farhan on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class Cache <Key: Hashable, Value> {
    
    let serialQueue = DispatchQueue(label: "com.farhan.RandomUsers.cacheQueue")
    
    private(set) var items = [Key: Value]()
    
    func cache(value: Value, key: Key){
        serialQueue.async {
            self.items.updateValue(value, forKey: key)
        }
    }
    
    func value(for key: Key) -> Value? {
        
        return serialQueue.sync { () -> Value? in
            if items.keys.contains(key){
                return items[key]!
            } else {
                return nil
            }
        }
    }
    
}
