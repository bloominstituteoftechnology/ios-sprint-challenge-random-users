//
//  Cache.swift
//  Random Users
//
//  Created by Ivan Caldwell on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
class Cache<Key: Hashable, Value>{
    private var cacheDictionary: [Key:Value] = [:]
    private let queue = DispatchQueue(label: "cacheQueue")
    
    func cache(key: Key, value: Value){
        queue.async{
            self.cacheDictionary[key] = value
        }
    }
    
    func value(key: Key) -> Value?{
        return queue.sync { cacheDictionary[key] }
    }
}
