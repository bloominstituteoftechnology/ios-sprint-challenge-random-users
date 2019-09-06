//
//  FetchPhotoOperation.swift
//  Astronomy
//
//  Created by Farhan on 10/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

class FetchThumbnailOperation: ConcurrentOperation {
    
    var thumbnailURL: URL
    var imageData: Data?
    
    var dataTask: URLSessionDataTask {
        return URLSession.shared.dataTask(with: thumbnailURL) { (data, _, _) in
            
            guard let data = data else {
//                NSLog("Data Corrupted")
                return
            }
            
            self.imageData = data
            
            defer {
                self.state = .isFinished
            }
        }
    }
    
    init(thumbnailURL: URL) {
        self.thumbnailURL = thumbnailURL
    }
    
    override func start() {
        state = .isExecuting
        dataTask.resume()
    }
    
    override func cancel() {
        dataTask.cancel()
    }
    
    
}
