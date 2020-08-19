//
//  FetchLargeImageOperation.swift
//  Random Users
//
//  Created by Ryan Murphy on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchLargeImageOperation: ConcurrentOperation {
    
    var user: User
    var imageData: Data?
    
    
    private var dataTask: URLSessionDataTask?
    
    init(user: User) {
        self.user = user
    }
    
    override func start() {
        state = .isExecuting
        
        let url = URL(string: user.picture.large)!
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            defer { self.state = .isFinished }
            
            if let error = error {
                NSLog("Error connnecting to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Data could not be fetched.")
                return
            }
            
            self.imageData = data
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    
    }
}
