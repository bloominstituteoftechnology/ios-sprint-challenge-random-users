//
//  Cache.swift
//  Random Users
//
//  Created by Michael Flowers on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
class Cache<Key: Hashable, Value> {
    private var cachedItems = [ Key : Value ]()
    
    //create a private queue
    private let queue = DispatchQueue(label: "com.michaelFlowers.lambdaSchoolSprint.Randomusers")
    
    //add items to the cache
    func cacheAdd(value: Value, forKey key: Key){
        //add to cache on the queue we just created, background serial queue
        queue.async {
            self.cachedItems[key] = value
        }
    }
    
    //return item/pop from cache
    func returnCachedValue(forKey key: Key) -> Value? {
        return queue.sync {
            cachedItems[key]
        }
    }
}
