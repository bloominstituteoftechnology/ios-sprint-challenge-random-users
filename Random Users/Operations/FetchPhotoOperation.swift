//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Scott Bennett on 10/12/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit

class FetchPhotoOperation: ConcurrentOperation {
    
    // MARK: - Properties
    
    var imageData: Data?
    var task: URLSessionDataTask?
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    // Fetch thumbnail images
    override func start() {
        state = .isExecuting
        
        let imageURL = user.thumbNail
        
        task = URLSession.shared.dataTask(with: imageURL, completionHandler: { data, _, error in
            if let error = error {
                NSLog("Error loading image: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No image data error")
                return
            }
            
            self.imageData = data
            
            defer {
                self.state = .isFinished      
            }
        })
        task?.resume()
    }
    
    override func cancel() {
            task?.cancel()
    }
}
