//
//  FetchUserOperation.swift
//  Random Users
//
//  Created by Bradley Yin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchUserPhotoOperation: ConcurrentOperation {
    var imageURL: String
    var imageData: Data?
    
    init(imageURL: String) {
        self.imageURL = imageURL
    }
    
    var loadImageDataTask : URLSessionDataTask {
        guard let url = URL(string: imageURL) else { return URLSessionDataTask() }
        
        return URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer {
                self.state = .isFinished
            }
            if let error = error {
                NSLog("Error doing load image dataTask: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("no data return on load image")
                return
            }
            
            self.imageData = data
            //print("load from internet")
            
        }
    }
    
    override func start() {
        state = .isExecuting
        loadImageDataTask.resume()
    }
    
    override func cancel() {
        loadImageDataTask.cancel()
    }
    
}
