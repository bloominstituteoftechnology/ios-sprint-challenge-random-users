//
//  ImageFetchOperation.swift
//  Random Users
//
//  Created by Victor  on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class ImageFetchOperation: ConcurrentOperation {
    var user: User
    var imageData: Data?
    private var dataTask: URLSessionDataTask?
    
    init(with user: User) {
        self.user = user
    }
    
    override func start() {
        self.state = .isExecuting
        
        let baseURL = user.pictureUrl
        let request = URLRequest(url: baseURL)
        
        dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image from network: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error loading image from network")
                return
            }
            
            self.imageData = data
            self.state = .isFinished
        }
        
        dataTask?.resume()
    }
    
    
}
