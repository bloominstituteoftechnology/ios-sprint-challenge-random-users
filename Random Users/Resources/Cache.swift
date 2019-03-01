//
//  Cache.swift
//  Random Users
//
//  Created by Jocelyn Stuart on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var queue = DispatchQueue(label: "CacheQueue")
    
    private var cacheSmallDict: [Key: Value] = [:]
    
    private var cacheLargeDict: [Key: Value] = [:]
    
    // small images
    
    func cacheSmall(value: Value, for key: Key) {
        queue.sync {
            cacheSmallDict[key] = value
        }
    }
    
    func valueSmall(for key: Key) -> Value? {
        return queue.sync {
            cacheSmallDict[key]
        }
    }
    
    // Large images
    
    func cacheLarge(value: Value, for key: Key) {
        queue.sync {
            cacheLargeDict[key] = value
        }
    }
    
    func valueLarge(for key: Key) -> Value? {
        return queue.sync {
            cacheLargeDict[key]
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
