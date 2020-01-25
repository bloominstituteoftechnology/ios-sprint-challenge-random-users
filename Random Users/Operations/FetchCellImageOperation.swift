//
//  FetchCellImageOperation.swift
//  Random Users
//
//  Created by Enayatullah Naseri on 1/24/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchCellImageOperation: ConcurrentOperation {
    
    var user: User
    var thumbNailImage: UIImage?
    private var dataTask: URLSessionDataTask?
    
    
    init(user: User) {
        self.user = user
    }
    
    override func start() {
        state = .isExecuting
        
        let imageUrl = user.thumbnailImage
        
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
            self.thumbNailImage = UIImage(data: data)
        }
        
        dataTask?.resume()
        
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
}
