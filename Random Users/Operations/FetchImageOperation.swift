//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Ivan Caldwell on 2/2/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import Foundation

class FetchImageOperation: ConcurrentOperation {
    
    var randomUser: RandomUser
    var imageData: Data? = nil
    private var dataTask: URLSessionDataTask?
    
    init(randomUser: RandomUser) {
        self.randomUser = randomUser
    }
    
    override func start() {
        super.start()
        self.state = .isExecuting
        
        let url = URLRequest(url: randomUser.thumbnail)
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image from data task: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned.")
                return
            }
            
            self.imageData = data
            self.state = .isFinished
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
    

