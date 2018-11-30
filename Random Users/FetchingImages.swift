//
//  FetchingImages.swift
//  Random Users
//
//  Created by Yvette Zhukovsky on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit


class FetchingImages: ConcurrentOperation {
    
    init( randomUsers: RandomUser) {
        self.randomUsers = randomUsers
    }

    override func start() {
        state = .isExecuting
        
        guard let url = randomUsers.largeImageURL else {return}
        task = URLSession.shared.dataTask(with: url) {(data, _, error) in
        defer {self.state  = .isFinished}
        
        if let error = error {
            NSLog("error fetching images\(error)")
            return
            
        }
            guard let data = data else {
                NSLog("no data")
                return
            }
            self.Image = UIImage(data: data)
    }
    task?.resume()
    }
    
    
    override func cancel() {
        task?.cancel()
    }
    
    
    
    private var task: URLSessionDataTask?
    var randomUsers: RandomUser
    var Image: UIImage?
    
}



