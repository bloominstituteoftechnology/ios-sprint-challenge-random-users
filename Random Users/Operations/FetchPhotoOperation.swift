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
    
    var image: UIImage? = nil
    let userReference: RandomUser
    private var dataTask: URLSessionDataTask?
    
    init(userReference: RandomUser) {
        self.userReference = userReference
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        guard let tempURL = URL(string: userReference.picture.large) else { return }
        guard let url = tempURL.usingHTTPS else { return }
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            defer { self.state = .isFinished }
            
            if let error = error {
                NSLog("Error GETing image for \(self.userReference.name): \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned")
                return
            }
            
            self.image = UIImage(data: data)
            return
        })
        dataTask?.resume()
    }
    
    
    override func cancel() {
        dataTask?.cancel()
    }
}
