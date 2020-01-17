//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Chad Rutherford on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    var imageData: Data?
    var imageURL: String
    var task: URLSessionDataTask?
    
    init(imageURL: String) {
        self.imageURL = imageURL
    }
    
    override func start() {
        self.state = .isExecuting
        
        guard let requestURL = URL(string: imageURL) else { return }
        
        task = URLSession.shared.dataTask(with: requestURL) { data, _, error in
            defer { self.state = .isFinished }
            
            if let _ = error {
                return
            }
            
            guard let data = data else { return }
            
            self.imageData = data
        }
        
        task?.resume()
    }
    
    override func cancel() {
        if let task = task {
            task.cancel()
        }
    }
}
