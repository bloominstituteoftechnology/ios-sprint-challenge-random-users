//
//  FetchUserOperation.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchUserOperation: ConcurrentOperation {
    var result: Result<Data, Error>?
    var imageURL: URL
    private (set) var imageData: UIImage?
    private var dataTask = URLSessionDataTask()
  
    init(imageURL: URL, imageData: UIImage? = nil) {
        self.imageURL = imageURL
        self.imageData = imageData
    }
    
    override func start() {
        if isCancelled { return }
        
        state = .isExecuting
        
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            defer { self.state = .isFinished }
            
            if let error = error {
                self.result = .failure(error)
                return
            }
            
            guard let data = data else {
                self.result = .success(Data())
                return
            }
            
            self.result = .success(data)
        }
        
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask.cancel()
    }
}
