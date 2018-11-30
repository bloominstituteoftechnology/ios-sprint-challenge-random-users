//
//  Cache.swift
//  Random Users
//
//  Created by Yvette Zhukovsky on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class Cache <Key: Hashable, Value> {
    
    func cache(value: Value, for key: Key){
        queue.async {
            self.cachedItems[key] = value
        }
        
        
    }
    
    
    
    func value(for key: Key)-> Value? {
        return queue.sync {
            return self.cachedItems[key]
}
        
    }
    
    
    
    private var queue = DispatchQueue(label: "com.Yvette.SprintChallenge7")
    private var cachedItems: [Key : Value] = [:]
}
