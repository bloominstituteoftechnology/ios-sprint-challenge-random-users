//
//  FetchPicture.swift
//  Random Users
//
//  Created by Nathan Hedgeman on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPicture: ConcurrentOperation {
    
    let user: User
    var pictureData: Data?
    
    init(user: User) {
        self.user = user
    }
    
    private var dataTask: URLSessionDataTask?
    
    override func start() {
        super.start()
        state = .isExecuting
        
        let imageURL = URL(string: user.picture["thumbnail"]!)!
        
        dataTask = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, _, error) in
            
            defer {
                self.state = .isFinished
            }
            
            if self.isCancelled {
                return
            }
            
            if let error = error {
                NSLog("Error fetching: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data returned: \(String(describing: error))")
                return
            }
            
            self.pictureData = data
        })
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
