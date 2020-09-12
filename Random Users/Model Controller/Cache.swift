//
//  Cache.swift
//  Random Users
//
//  Created by Norlan Tibanear on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


class Cache <Key: Hashable, Value> {
   
    private var imageCache: [Key : Value] = [:]
    
    private let queue = DispatchQueue(label: "Cache Image Queue")
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.imageCache[key] = value
        }
    }
    
    
    func value(for key: Key) -> Value? {
        queue.sync {
            return imageCache[key]
        }
    }
    
    
}//
