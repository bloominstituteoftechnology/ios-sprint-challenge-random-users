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
    
//    let largeImageUrl: URL
//    let thumbnailImageUrl: URL?
    let users: Users
    var imageData: Data?
    
    private var dataTask: URLSessionDataTask?
    
    init(users: Users) {
       self.users = users
//        self.largeImageUrl = URL(string: users.large)!.usingHTTPS!
//        self.thumbnailImageUrl = URL(string: users.thumbnail)!.usingHTTPS!
        super.init()
    }
    
    
    override func start() {
        state = .isExecuting
        
        guard let imageUrl = URL(string: users.large) else {return}
        
        dataTask = URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, _, error) in
            
            
            defer { self.state = .isFinished }
            
            
            
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
