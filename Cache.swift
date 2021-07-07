//
//  Cache.swift
//  Random Users
//
//  Created by Simon Elhoej Steinmejer on 07/09/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value>
{
    private var thumbnailDictionary: [Key: Value] = [:]
    private var largeDictionary: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "dk.SimonElhoej.GCD.SerialQueue")
    
    func addToCache(thumbnail: Value, key: Key)
    {
        queue.async {
            self.thumbnailDictionary[key] = thumbnail
//            self.largeDictionary[key] = large
        }
    }
    
    func thumbnail(for key: Key) -> Value?
    {
        return queue.sync { return thumbnailDictionary[key] }
    }
    
    func large(for key: Key) -> Value?
    {
        return queue.sync { return largeDictionary[key] }
    }
    
    func imageIsCached(id: Key) -> Bool
    {
        for (key, _) in thumbnailDictionary
        {
            if key == id
            {
                return true
            }
        }

        return false
    }
}
