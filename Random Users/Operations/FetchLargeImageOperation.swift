//
//  FetchLargeImageOperation.swift
//  Random Users
//
//  Created by Iyin Raphael on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class FetchLargeImageOperation: ConcurrentOperation {
    
    init(randomUser: RandomUser) {
        self.randomUser = randomUser
    }
    
    override func start() {
        state = .isExecuting
        
        guard let url = randomUser.largeImageURL else { return }
        dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            defer { self.state = .isFinished }
            
            if let error = error {
                NSLog("Error retrieving image: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data found.")
                return
            }
            self.largeImage = UIImage(data: data)
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
    
    var randomUser: RandomUser
    var largeImage: UIImage?
    private var dataTask: URLSessionDataTask?
}
