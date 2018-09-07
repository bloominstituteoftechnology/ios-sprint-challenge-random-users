//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Conner on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    init(user: User) {
        self.user = user
    }
    
    override func start() {
        state = .isExecuting
        
        let imageURL = URL(string: user.picture.medium)!
        
        task = URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            defer { self.state = .isFinished }
            if let error = error {
                NSLog("Error fetching photo in FetchPhotoOperation: \(error)")
                return
            }
            
            if let data = data {
                self.imageData = data
            }
            
        }
        task.resume()
    }
    
    override func cancel() {
        task.cancel()
    }
    
    // MARK: - Properties
    var user: User
    var imageData: Data?
    var task: URLSessionDataTask = URLSessionDataTask()
}
