//
//  FetchLargePhotoOperation.swift
//  Random Users
//
//  Created by Moses Robinson on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class FetchLargePhotoOperation: ConcurrentOperation {
    
    var user: User
    var image: UIImage?
    
    init(user: User) {
        self.user = user
    }
    
    override func start() {
        state = .isExecuting
        
        let url = user.largeImageURL
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error getting image: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data found")
                return
            }
            
            guard let image = UIImage(data: data) else {
                NSLog("Could not construct image from data")
                return
            }
            
            self.image = image
            
            defer { self.state = .isFinished }
        }
        dataTask.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
    
    // MARK: - Properties
    
    private var dataTask: URLSessionDataTask?
}
