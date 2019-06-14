//
//  FetchThumbnailOperation.swift
//  Random Users
//
//  Created by Hayden Hastings on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchThumbnailOperation: ConcurrentOperation {
    
    // MARK: - Properties
    var user: User
    var image: UIImage?
    
    private var task: URLSessionDataTask?
    
    init(user: User) {
        self.user = user
    }
    
    override func start() {
        state = .isExecuting
        
        let thumbURL = user.imageThumbnailURL
        
        let dataTask = URLSession.shared.dataTask(with: thumbURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Unable fetching image: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Unable to get data")
                return
            }
            
            guard let image = UIImage(data: data) else {
                NSLog("Unable to get image from respective data.")
                return
            }
            
            self.image = image
            
            defer { self.state = .isFinished }
        }
        
        dataTask.resume()
    }
    
    override func cancel() {
        task?.cancel()
    }
}
