//
//  FetchUserOperation.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchUserOperation: ConcurrentOperation {
    var result: Result<Data, Error>?
    private (set) var imageData: Data?
    private var dataTask = URLSessionDataTask()
    var url: URL
    
    init(url: URL, imageData: Data) {
        self.url = url
        self.imageData = imageData
    }
    
    
    override func start() {
        if isCancelled { return }
        
        state = .isExecuting
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
