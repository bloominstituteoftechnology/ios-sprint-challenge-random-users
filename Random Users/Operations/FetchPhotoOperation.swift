//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Dahna on 6/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


class FetchPhotoOperation: ConcurrentOperation {
    
    var user: User
    var imageData: Data?
    private var dataTask: URLSessionDataTask?
    
    init(user: User) {
        self.user = user
    }
    
    override func start() {
        state = .isExecuting
        
        let url = user.picture.large
        
        dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            defer {
                self.state = .isFinished
            }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error Fetching Operation: \(error)")
                return
            }
            if let data = data {
                self.imageData = data
            }
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        if self.isCancelled {
            if let task = dataTask {
                task.cancel()
            }
        }
    }
}
