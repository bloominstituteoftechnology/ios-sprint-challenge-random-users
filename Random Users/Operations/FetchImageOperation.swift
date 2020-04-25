//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Jason Modisett on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImageOperation: ConcurrentOperation {
    
    // MARK:- Initializer
    init(url: String) {
        self.url = URL(string: url)!
    }
    
    // MARK:- Properties & types
    var url: URL
    var imageData: Data?
    
    var dataTask: URLSessionDataTask {
        return URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let _ = error { return }
            
            guard let data = data else {
                NSLog("No data found while performing the data task")
                return
            }
            
            self.imageData = data
            
            defer { self.state = .isFinished }
        }
    }
    
    // MARK:- NSOperation overrides
    override func start() {
        state = .isExecuting
        dataTask.resume()
    }
    
    override func cancel() {
        dataTask.cancel()
    }
    
}
