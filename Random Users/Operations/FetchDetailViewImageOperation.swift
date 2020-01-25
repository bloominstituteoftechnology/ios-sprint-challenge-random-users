//
//  FetchDetailViewImageOperation.swift
//  Random Users
//
//  Created by Enayatullah Naseri on 1/24/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchDetailViewImageOperation: ConcurrentOperation {
    
    var user: User
    var largeImage: UIImage?
    private var dataTask: URLSessionDataTask?
    
    init(user: User) {
        self.user = user
    }
    
    // start loading image
    override func start() {
        state = .isExecuting
        
        let imageUrl = user.largeImage
        
        dataTask = URLSession.shared.dataTask(with: imageUrl) { (data, _, error) in
            defer { self.state = .isFinished }
            
            // Error handaling
            if let error = error {
                NSLog("Error fetching image: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data was found")
                return
            }
            
            guard let image = UIImage(data: data) else {
                NSLog("Cannot load image: \(String(describing: error))")
                return
            }
            
            self.largeImage = image
            self.largeImage = UIImage(data: data)
        }
        
        dataTask?.resume()
        
    }
    
    
    override func cancel() {
        dataTask?.cancel()
    }
}
