//
//  Cache.swift
//  Random Users
//
//  Created by Tobi Kuyoro on 13/03/2020.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private let queue = DispatchQueue(label: "CacheQueue")
    private var largeImageDictionary: [Key: Value] = [:]
    private var thumbnailImageDictionary: [Key: Value] = [:]
    
    func largeImageCache(value: Value, for key: Key) {
        queue.async {
            self.largeImageDictionary[key] = value
        }
    }
    
    func largeImageValue(for key: Key) -> Value? {
        queue.sync {
            return self.largeImageDictionary[key]
        }
    }
    
    func thumbnailImageCache(value: Value, for key: Key) {
        queue.async {
            self.thumbnailImageDictionary[key] = value
        }
    }
    
    func thumbnailImageValue(for key: Key) -> Value? {
        queue.sync {
            return self.thumbnailImageDictionary[key]
        }
    }
}
