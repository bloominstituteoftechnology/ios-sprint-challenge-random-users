//
//  FetchThumbOperations.swift
//  Random Users
//
//  Created by Jarren Campos on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchThumbnailOperation: ConcurrentOperation {
    let user: User
    let imageURLString: String
    var imageData: Data?
    
    private var dataTask: URLSessionDataTask {
        let imageURL: URL = URL(string: imageURLString)!
        
        return URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                return
            }
            self.imageData = data
            do { self.state = .isFinished }
        }
    }
    
    init(user: User, imageURL: String) {
        self.user = user
        self.imageURLString = imageURL
    }
    
    override func start() {
        state = .isExecuting
        dataTask.resume()
    }
    
    override func cancel() {
        dataTask.cancel()
    }
}
