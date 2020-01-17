//
//  PictureCache.swift
//  Random Users
//
//  Created by Nathan Hedgeman on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class PictureCache<Key: Hashable, Value> {
    
    private var queue = DispatchQueue(label: "Cache")
    private var thumbnailDictionary: [Key: Value] = [:]
    private var largePictureDictionary: [Key: Value] = [:]
    
    func cacheThumbnails(value: Value, for key: Key) {
        queue.sync {
            thumbnailDictionary[key] = value
        }
    }
    
    func thumbnailValue(for key: Key) -> Value? {
        return queue.sync {
            thumbnailDictionary[key]
        }
    }
    
    func cacheLargePictures(value: Value, for key: Key) {
        queue.sync {
            largePictureDictionary[key] = value
        }
    }
    
    func largePictureValue(for key: Key) -> Value? {
        return queue.sync {
            largePictureDictionary[key]
        }
    }
}
