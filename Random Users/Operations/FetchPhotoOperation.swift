//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Benjamin Hakes on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit
/**
 This code is represents  a nice "boilerplate" class that makes it easier to implement concurrent/asynchronous Operation subclasses in Swift.
 
 Might want to keep this around as it can be useful for other applications.
 
 */


class FetchPhotoOperation: ConcurrentOperation {
    
    var imageData: Data? = nil
    let user: RandomUser
    private var dataTask: URLSessionDataTask?
    
    init(user: RandomUser) {
        self.user = user
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        guard let tempURL = URL(string: user.picture.thumbnail) else { return }
        guard let url = tempURL.usingHTTPS else { return }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            defer { self.state = .isFinished }
            
            if let error = error {
                NSLog("Error GETing image for \(self.user.name.last) with ID: \(self.user.uid.uuidString): \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned")
                return
            }
            
            self.imageData = data
            return
        })
        dataTask?.resume()
    }
    
    
    override func cancel() {
        dataTask?.cancel()
    }
}
