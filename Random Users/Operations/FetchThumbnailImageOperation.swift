//
//  FetchThumbnailImageOperation.swift
//  Random Users
//
//  Created by Ilgar Ilyasov on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class FetchThumbnailImageOperation: ConcurrentOperation {
    
    // MARK: - Properties
    
    var user: User
    var thumbnailImage: UIImage!
    var task: URLSessionDataTask!
    
    
    // MARK: - Initializer
    
    init(user: User) {
        self.user = user
    }
    
    
    // MARK: - Start
    
    override func start() {
        state = .isExecuting
        
        guard let thumbnailImageURL = user.thumbnailURL else { return }
        
        task = URLSession.shared.dataTask(with: thumbnailImageURL, completionHandler: { (data, _, error) in
            defer { self.state = .isFinished}
            
            if error != nil {
                NSLog("Error loading thumbnail images")
                return
            }
            
            guard let data = data else {
                NSLog("No thumbnail image data returned")
                return
            }
            
            self.thumbnailImage = UIImage(data: data)
        })
        
        task.resume()
    }
    
    // MARK: - Cancel
    
    override func cancel() {
        task.cancel()
    }
    
}
