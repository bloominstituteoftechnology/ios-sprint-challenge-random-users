//
//  FetchUserOperation.swift
//  Random Users
//
//  Created by Nathanael Youngren on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchThumbnailImageOperation: ConcurrentOperation {
    
    var user: User
    var imageData: Data?
    private var dataTask: URLSessionDataTask?
    
    init(user: User) {
        self.user = user
    }
    
    override func start() {
        state = .isExecuting
        
        dataTask = URLSession.shared.dataTask(with: user.thumbnailImage) { (data, _, error) in
            defer { self.state = .isFinished }
            
            if let error = error {
                NSLog("Error connnecting to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Data could not be fetched.")
                return
            }
            
            self.imageData = data
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
