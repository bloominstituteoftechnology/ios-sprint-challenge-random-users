//
//  FetchLargeImageOperation.swift
//  Random Users
//
//  Created by Ilgar Ilyasov on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class FetchLargeImageOperation: ConcurrentOperation {
    
    // MARK: - Properties
    
    var user: User
    var largeImage: UIImage!
    var task: URLSessionDataTask!
    
    
    // MARK: - Initializer
    
    init(user: User) {
        self.user = user
    }
    
    
    // MARK: - Start
    
    override func start() {
        state = .isExecuting
        
        guard let largeImageURL = user.largeURL else { return }
        
        task = URLSession.shared.dataTask(with: largeImageURL, completionHandler: { (data, _, error) in
            defer { self.state = .isFinished }
            
            if error != nil {
                NSLog("Error loading large images: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No large image data returned")
                return
            }
            
            self.largeImage = UIImage(data: data)
        })
        
        task.resume()
    }
    
    
    // MARK: - Cancel
    
    override func cancel() {
        task.cancel()
    }
    
}
