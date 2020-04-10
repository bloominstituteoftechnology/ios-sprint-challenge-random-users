//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Wyatt Harrell on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum ImageType {
    case large
    case medium
    case thumbnail
}

class FetchPhotoOperation: ConcurrentOperation {
    
    var user: Result
    private var dataTask = URLSessionDataTask()
    var imageData: Data?
    var imageType: ImageType
    
    init(user: Result, imageType: ImageType) {
        self.user = user
        self.imageType = imageType
    }
    
    override func start() {
        state = .isExecuting
        
        var imageURL: URL?
        
        switch imageType {
        case .large:
            imageURL = user.picture.large
        case .medium:
            imageURL = user.picture.medium
        case .thumbnail:
            imageURL = user.picture.thumbnail
        }
        
        var request = URLRequest(url: imageURL!)
        request.httpMethod = "GET"
        
        dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                NSLog("Error receiving image data: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("API responded with no image data")
                return
            }
            
            self.imageData = data
            self.state = .isFinished
        })
        dataTask.resume()
        
        
    }
    
    override func cancel() {
        dataTask.cancel()
    }
    
}
