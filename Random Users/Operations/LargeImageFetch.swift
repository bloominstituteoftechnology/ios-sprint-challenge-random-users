//
//  LargeImageFetch.swift
//  Random Users
//
//  Created by Sameera Roussi on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class LargeImageFetch: ConcurrentOperation {
    
    init(randomUser: RandomUser) {
        self.randomUser = randomUser
    }
    
    override func start() {
        state = .isExecuting
        
        // MARK: -  URL fetch Session
        guard let url = randomUser.thumbNailURL else { return }
        task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            defer { self.state = .isFinished }
            
            // Check for errors
            if let error = error {
                NSLog("Error retrieving large image: \(error)")
                return
            }
            
            // Check for the thumbnail data
            guard let data = data else {
                NSLog("Not able to fetch large image data")
                return
            }
            // Store the thumbnail
            self.largeImage = UIImage(data: data)
        }
        task?.resume()
    }
    
    
    // MARK: - Cancel function
    override func cancel() {
        task?.cancel()
    }
    
    
    // MARK: - Properties
    var randomUser: RandomUser
    private var task: URLSessionDataTask?
    var largeImage: UIImage?
    
}

