//
//  FetchPictureOperation.swift
//  Random Users
//
//  Created by Gi Pyo Kim on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPictureOperation: ConcurrentOperation {
    
    private var dataTask: URLSessionTask?
    let pictureReference: Picture
    var thumbnailData: Data?
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
            
            guard let data = data else {
                NSLog("Invalid Data")
                return
            }
            
            self.thumbnailData = data
            
            guard let largeURL = URL(string: self.pictureReference.large) else { return }
            var largeRequestURL = URLRequest(url: largeURL)
            largeRequestURL.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: largeRequestURL) { (data, _, error) in
                if let error = error {
                    NSLog("Error fetching large picture: \(error)")
                    return
                }
                
                defer {
                    self.state = .isFinished
                }
                
                guard let data = data else {
                    NSLog("Invalid Data")
                    return
                }
                
                self.largeData = data
            }.resume()
        })
        dataTask?.resume()
        
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
    
}
