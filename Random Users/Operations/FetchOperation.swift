//
//  FetchOperation.swift
//  Random Users
//
//  Created by Joseph Rogers on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchContactOperation: ConcurrentOperation {
    // MARK: Properties
    private (set) var imageData: Data?
    private var dataTask: URLSessionTask?
    let contact: User
    
    // MARK: Initializer
    init(user: User) {
        self.contact = user
        super.init()
    }
    
    // MARK: Methods
    override func start() {
        super.start()
        state = .isExecuting
        
        let url = self.contact.thumbnailImage
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
