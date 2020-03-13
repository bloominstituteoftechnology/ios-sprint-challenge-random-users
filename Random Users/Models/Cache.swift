//
//  Cache.swift
//  Random Users
//
//  Created by Elizabeth Wingate on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var queue = DispatchQueue(label: "CacheQ")
    
    private var cacheSmallDictionary: [Key: Value] = [:]
    
    private var cacheLargeDictionary: [Key: Value] = [:]
    
    func cacheSmall(value: Value, for key: Key) {
        queue.sync {
            cacheSmallDictionary[key] = value
        }
    }
    
    func valueSmall(for key: Key) -> Value? {
        return queue.sync {
            cacheSmallDictionary[key]
        }
    }
    
    func cacheLarge(value: Value, for key: Key) {
         queue.sync {
             cacheLargeDictionary[key] = value
         }
     }
     
     func valueLarge(for key: Key) -> Value? {
         return queue.sync {
             cacheLargeDictionary[key]
         }
     }
}

class FetchPhotoOperation: ConcurrentOperation {
    let user: Result
    
    var imageData: Data?
    
    init(user: Result) {
        self.user = user
    }
    
    private var photoDataTask: URLSessionDataTask?
    
    override func start() {
        state = .isExecuting
        
        let imageURL = URL(string: user.picture["thumbnail"]!)!
        
        photoDataTask = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data returned: \(error)")
                return
            }
            
            self.imageData = data
            defer {
                self.state = .isFinished
            }
    
        })
        photoDataTask?.resume()
        
    }
    
    override func cancel() {
        photoDataTask?.cancel()
    }
}
