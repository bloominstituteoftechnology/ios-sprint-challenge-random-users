//
//  FetchOperation.swift
//  Random Users
//
//  Created by Joshua Rutkowski on 3/22/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchOperation: ConcurrentOperation {
    
    let photoReference: String
    var imageData: Data?
    private var dataTask: URLSessionDataTask?
    
    init(photoReference: String) {
        self.photoReference = photoReference
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        
        guard let thumbNailURL = URL(string: photoReference)?.usingHTTPS
            else { return }
        dataTask = URLSession.shared.dataTask(with: thumbNailURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data for \(self.photoReference): \(error)")
            }
            
            guard let data = data else { return }
            self.imageData = data
            self.state = .isFinished
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
}
