//
//  Cache.swift
//  Random Users
//
//  Created by Kevin Stewart on 5/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class Cache<Key: Hashable, Value> {
    
    let queue = DispatchQueue(label: "Caching-Queue")
    var thumbnailPictureDict: [Key : Value] = [:]
    var largePictureDict: [Key : Value] = [:]
    
    func thumbnailPictureCache(value: Value, for key: Key) {
        queue.async { self.thumbnailPictureDict[key] = value }
    }
    
    func thumbnailPictureValue(for key: Key) -> Value? {
        return queue.sync { thumbnailPictureDict[key] }
    }
    
    func largPictureCache(value: Value, for key: Key) {
        queue.async { self.largePictureDict[key] = value }
    }
    
    func largePictureValue(for key: Key) -> Value? {
        return queue.sync { largePictureDict[key] }
    }
    

    
}
