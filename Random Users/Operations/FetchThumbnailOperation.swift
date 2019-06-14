//
//  FetchThumbnailOperation.swift
//  Random Users
//
//  Created by Hayden Hastings on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchThumbnailOperation: ConcurrentOperation {
    
    let photoReference: User
    private(set) var imageData: Data?
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    
    override func start() {
        state = .isExecuting
        let url = photoReference.imageThumbnailURL.usingHTTPS!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for \(self.photoReference): \(error)")
                return
            }
            
            self.imageData = data
        }
        
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
    init(photoReference: User, session: URLSession = URLSession.shared) {
        self.photoReference = photoReference
        self.session = session
        super.init()
    }
}
