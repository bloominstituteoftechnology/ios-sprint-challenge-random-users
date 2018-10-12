//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Daniela Parra on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    init(user: User) {
        self.user = user
    }
    
    override func start() {
        state = .isExecuting
        
        let imageURL = user.thumbnailURL
        photoDataTask = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned.")
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
    
    let user: User
    var imageData: Data?
    var photoDataTask: URLSessionDataTask?
}
