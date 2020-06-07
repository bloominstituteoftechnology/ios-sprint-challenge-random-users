//
//  ImageFetchOperation.swift
//  Random Users
//
//  Created by Vincent Hoang on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class ImageFetchOperation: ConcurrentOperation {
    var user: User
    
    var imageFetchTask: URLSessionDataTask?
    var image: Data?
    
    init(_ user: User) {
        self.user = user
    }
    
    override func start() {
        state = .isExecuting
        
        let url = URL(string: user.picture.thumbnail)!
        
        imageFetchTask = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                NSLog("Error fetching image: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data returned while fetching image")
                return
            }
            
            self.image = data
        }
        
        if let task = imageFetchTask {
            task.resume()
        }
    }
    
    override func cancel() {
        if let task = imageFetchTask {
            task.cancel()
        }
    }
    
    
}
