//
//  FetchLargeImageOperation.swift
//  Random Users
//
//  Created by Farhan on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class FetchLargeImageOperation: ConcurrentOperation {
    
    var largeImageURL: URL
    var imageData: Data?
    
    var dataTask: URLSessionDataTask {
        return URLSession.shared.dataTask(with: largeImageURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error Initializing DataTask: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Data Corrupted")
                return
            }
            
            self.imageData = data
            
            defer {
                self.state = .isFinished
            }
        }
    }
    
    init(largeImageURL: URL) {
        self.largeImageURL = largeImageURL
    }
    
    override func start() {
        state = .isExecuting
        dataTask.resume()
    }
    
    override func cancel() {
        dataTask.cancel()
    }
    
    
}
