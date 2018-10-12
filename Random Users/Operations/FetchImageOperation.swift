//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Moin Uddin on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation


class FetchImageOperation: ConcurrentOperation {
    var imageUrl: URL
    var task: URLSessionDataTask = URLSessionDataTask()
    var imageData: Data?
    
    init(imageUrl: URL) {
        self.imageUrl = imageUrl
    }
    
    override func start() {
        state = .isExecuting
        task = URLSession.shared.dataTask(with: imageUrl) { (data, _, error) in
            defer { self.state = .isFinished }
            if let error = error {
                NSLog("Fetch Operation Error with image Data Request: \(error)")
                return
            }
            guard let data = data else {
                NSLog("Error returning data \(error)")
                return
            }
            self.imageData = data
        }
        task.resume()
    }
    
    override func cancel() {
        task.cancel()
    }
    
    
}
