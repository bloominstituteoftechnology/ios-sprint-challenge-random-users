//
//  FetchImageOp.swift
//  Random Users
//
//  Created by Dennis Rudolph on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImageOp: ConcurrentOperation {
    let picURL: URL
    var imageData: Data?
    var dataTask: URLSessionDataTask?
    
    init(pic: URL) {
        self.picURL = pic
    }
    
    override func start() {
        state = .isExecuting
        
        dataTask = URLSession.shared.dataTask(with: picURL, completionHandler: { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image: \(error)")
                return
            }
            
            self.imageData = data
            self.state = .isFinished
        })
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
}
