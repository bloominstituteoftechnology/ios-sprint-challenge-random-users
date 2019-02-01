//
//  Cache.swift
//  Random Users
//
//  Created by Lisa Sampson on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key, Value> where Key: Hashable {
    
    private let queue = DispatchQueue.init(label: "Cache storage Queue")
    
    private var tempImageStore: [Key : Value] = [:]
    
    func cache(value: Value, forKey: Key) {
        queue.async {
            
            self.tempImageStore[forKey] = value
        }
    }
    
    func value(forKey: Key) -> Value?  {
        
        
        return queue.sync {
            return tempImageStore[forKey]
            
        }
        
    }
    
}
