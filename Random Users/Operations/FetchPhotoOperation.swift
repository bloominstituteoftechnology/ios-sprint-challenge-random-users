//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Seschwan on 8/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

// This is a seperate operation to just fetch the photos on a seperate Q?

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
        
        let url = self.user.thumbnail
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
