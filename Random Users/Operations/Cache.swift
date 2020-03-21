//
//  Cache.swift
//  Random Users
//
//  Created by Sal B Amer LpTop on 21/3/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class Cache<Key: Hashable, Value> {
    
    let queue = DispatchQueue(label: "Caching-Queue")
    var thumbnailImageDict: [Key : Value] = [:]
    var largeImageDict: [Key : Value] = [:]
    
    func thumbnailImageCache(value: Value, for key: Key) {
        queue.async {
            self.thumbnailImageDict[key] = value
        }
    }
    
    func thumbnailImageValue(for key: Key) -> Value? {
        queue.sync {
            return self.thumbnailImageDict[key]
        }
    }
    
    func largeImageCache(value: Value, for key: Key) {
        queue.async {
            self.largeImageDict[key] = value
        }
    }
    
    func largeImageValue(for key: Key) -> Value? {
        queue.sync {
            return self.largeImageDict[key]
        }
    }
    
}

