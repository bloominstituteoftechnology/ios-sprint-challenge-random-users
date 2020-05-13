//
//  UserFetchOperation.swift
//  Random Users
//
//  Created by De MicheliStefano on 07.09.18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
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
    
    override func cancel() {
        dataTask?.cancel()
    }
    
}
