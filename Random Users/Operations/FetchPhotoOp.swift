//
//  FetchPhotoOp.swift
//  Random Users
//
//  Created by Jerrick Warren on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOp: ConcurrentOperation {
    
    let user: User
    var imageData: Data?
    var photoDataTask: URLSessionDataTask?
    
    init(user: User) {
        self.user = user
    }
    
    // Start (self.defer) - then Cancel methods
    
    override func start() {
        state = .isExecuting
        
        let imageURL = user.thumbnailURL
        photoDataTask = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned. Please check url.")
                return
            }
            
            self.imageData = data
            defer {
                self.state = .isFinished
            }
        })
        photoDataTask?.resume()
    }
    
    override func cancel() {
        photoDataTask?.cancel()
    }
}
