//
//  FetchPersonOperation.swift
//  Random Users
//
//  Created by Gi Pyo Kim on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPersonOperation: ConcurrentOperation {
    
    private var dataTask: URLSessionTask?
    let pictureReference: Picture
    var thumbnailData: Data? {
        didSet {
            guard let largeURL = URL(string: pictureReference.large) else { return }
            var largeRequestURL = URLRequest(url: largeURL)
            largeRequestURL.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: largeRequestURL) { (data, _, error) in
                if let error = error {
                    NSLog("Error fetching large picture: \(error)")
                    return
                }
                
                guard let data = data else {
                    NSLog("Invalid Data")
                    return
                }
                
                self.largeData = data
            }
        }
    }
    var largeData: Data?
    
    init(pictureReference: Picture) {
        self.pictureReference = pictureReference
    }
    
    override func start() {
        state = .isExecuting
        
        guard let thumbnailURL = URL(string: pictureReference.thumbnail) else { return }
        var thumbnailRequestURL = URLRequest(url: thumbnailURL)
        thumbnailRequestURL.httpMethod = "GET"
        
        dataTask = URLSession.shared.dataTask(with: thumbnailRequestURL, completionHandler: { (data, _, error) in
            if self.isCancelled { return }
            
            if let error = error {
                NSLog("Error fetching thumbnail: \(error)")
                return
            }
            
            defer {
                self.state = .isFinished
            }
            
            guard let data = data else {
                NSLog("Invalid Data")
                return
            }
            
            self.thumbnailData = data
        })
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
    
}
