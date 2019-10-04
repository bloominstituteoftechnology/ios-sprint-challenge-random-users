//
//  Cache.swift
//  Random Users
//
//  Created by Nathan Hedgeman on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var q = DispatchQueue(label: "Cache")
    private var thumbnailDictionary: [Key: Value] = [:]
    private var largePictureDictionary: [Key: Value] = [:]
    
    func cacheThumbnails(value: Value, for key: Key) {
        q.sync {
            thumbnailDictionary[key] = value
        }
    }
    
    func thumbnailValue(for key: Key) -> Value? {
        return q.sync {
            thumbnailDictionary[key]
        }
    }
    
    func cacheLargePictures(value: Value, for key: Key) {
        q.sync {
            largePictureDictionary[key] = value
        }
    }
    
    func largePictureValue(for key: Key) -> Value? {
        return q.sync {
            largePictureDictionary[key]
        }
    }
}
