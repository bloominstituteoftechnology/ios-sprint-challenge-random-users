//
//  PhotoFetchOperation.swift
//  Random Users
//
//  Created by Linh Bouniol on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class PhotoFetchOperation: ConcurrentOperation {
    
    let url: URL
    var pictureData: Data?
    
    private var dataTask: URLSessionDataTask?
    
    init(url: URL) {
        self.url = url
    }
    
    override func start() {
        state = .isExecuting
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error retrieving data: \(error)")
                return
            }
            
            guard let data = data else { return }
            self.pictureData = data
            
            defer {
                self.state = .isFinished
            }
        }
        
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }

}
