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
    
    var user: User?
    
    // var image: URL
    
    var imageData: Data?
    
    init(user: User) {
        self.user = user
    }
    
    private var dataTask: URLSessionDataTask?
    
    override func start() {
        state = .isExecuting
        
        let dataT = URLSession.shared.dataTask(with: URL(string: ((user?.thumbnail)!))!) { (data, _, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            self.imageData = data
            defer {
                self.state = .isFinished
            }
        }
        dataT.resume()
        dataTask = dataT
        
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
    
    
    
    
}
