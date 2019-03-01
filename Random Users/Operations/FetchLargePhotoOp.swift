//
//  FetchLargePhotoOp.swift
//  Random Users
//
//  Created by Julian A. Fordyce on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchLargePhotoOp: ConcurrentOperation {
    
    var user: User
    var image: UIImage?
    
    init(user: User) {
        self.user = user
    }
    
    override func start() {
        state = .isExecuting
        
        let thumbURL = user.largeURL
        
        let dataTask = URLSession.shared.dataTask(with: thumbURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Unable fetching image: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Unable to get data: \(String(describing: error))")
                return
            }
            
            guard let image = UIImage(data: data) else {
                NSLog("Unable to get image from respective data: \(String(describing: error))")
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
    
    // MARK: - Properties
    
    private var task: URLSessionDataTask?
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
