//
//  FetchUserOperations.swift
//  Random Users
//
//  Created by patelpra on 5/16/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchUserOperation: ConcurrentOperation {
    private (set) var imageData: Data?
    private var dataTask: URLSessionDataTask?
    
    let user: User
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    override func start() {
        super.start()
        state = .isExecuting
        
        let url = self.user.thumbnailImage
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                return
            }
            self.imageData = data
        }
        task.resume()
        self.dataTask = task
    }
    
    override func cancel() {
        super.cancel()
        if let task = self.dataTask {
            task.cancel()
        }
    }
}
