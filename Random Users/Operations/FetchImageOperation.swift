//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Stephanie Bowles on 8/15/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImageOperation: ConcurrentOperation {
    private (set) var imageData: Data?
    private var dataTask: URLSessionDataTask?
    
    let user: User
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    override func start(){
        super.start()
        state = .isExecuting
        
        let url = self.user.thumbnailPic
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { self.state = .isFinished}
            if self.isCancelled {return}
            
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
