//
//  fetchingThumbnails.swift
//  Random Users
//
//  Created by Yvette Zhukovsky on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class FetchingThumbnails: ConcurrentOperation {
    
    init( randomUsers: RandomUser) {
        self.randomUsers = randomUsers
    }
    
    override func start() {
        state = .isExecuting
        
        guard let url = randomUsers.thumbnailImageURL else {return}
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
            self.thumbail = UIImage(data: data)
        }
        task?.resume()
    }
    
    
    override func cancel() {
        task?.cancel()
    }
    
    
    
    private var task: URLSessionDataTask?
    var randomUsers: RandomUser
    var thumbail: UIImage?
    
    
    
    
    
    
    
    
    
    
    
}


