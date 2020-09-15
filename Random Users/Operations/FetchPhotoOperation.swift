//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Craig Belinfante on 9/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchPhotoOperation: ConcurrentOperation {
    
    // MARK - Properties
    var user: User
    var image: User.CodingKeys.PictureKey
    var imageData: Data?
    
    private var dataTask: URLSessionDataTask?
    
    init(user: User, image: User.CodingKeys.PictureKey) {
        self.user = user
        self.image = image
    }
    
    override func start() {
        state = .isExecuting
        
        let imageURL = URL(string: user.thumbnail)!
        let requestURL = URLRequest(url: imageURL)
        
        dataTask = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            defer {
                self.state = .isFinished
            }
            
            if let error = error {
                print("Error: \(error)")
            }
            
            guard let data = data else {return}
            self.imageData = data
        }
        
        dataTask?.resume()
        
    }
    override func cancel() {
        dataTask?.cancel()
        state = .isFinished
    }
}

