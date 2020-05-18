//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Matthew Martindale on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImageOperation: ConcurrentOperation {
    var user: User
    var imageData: Data?
    
    var fetchImageDataTask: URLSessionDataTask?
    
    init(user: User) {
        self.user = user
    }
    
    override func start() {
        state = .isExecuting
        
        let imageURL = URL(string: user.picture.thumbnail)!
        
        fetchImageDataTask = URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                NSLog("Error completing fetchImage dataTask: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error fetching data")
                return
            }
            self.imageData = data
        }
        fetchImageDataTask?.resume()
    }
    
    override func cancel() {
        fetchImageDataTask?.cancel()
    }
    
}
