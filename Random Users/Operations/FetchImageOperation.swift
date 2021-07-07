//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Nelson Gonzalez on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

import UIKit

class FetchImageOperation: ConcurrentOperation {
    
    let users: Users
    var imageData: Data?
    
    private var dataTask: URLSessionDataTask?
    
    init(users: Users) {
       self.users = users
        super.init()
    }
    
    
    override func start() {
        state = .isExecuting
        
        guard let imageUrl = URL(string: users.large) else {return}
        
        dataTask = URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, _, error) in
            
            
            defer { self.state = .isFinished }
            
            if self.isCancelled { return }
            
            if let error = error {
                print("Error with data task: \(error)")
            }
            
            guard let data = data else {
                print("Error getting data back")
                return
            }
            
            self.imageData = data
            
        })
        
        dataTask?.resume()
    }
    
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
