//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Kelson Hartle on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    let photoReference: User
    private(set) var imageData: Data?
    private(set) var imageDataTwo: Data?
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    private var dataTaskTwo: URLSessionTask?
    
    init(photoReference: User, session: URLSession = URLSession.shared) {
        self.photoReference = photoReference
        self.session = session
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        guard let thumbNailImage = photoReference.thumbnail.usingHTTPS else { return }
        let task = session.dataTask(with: thumbNailImage) { (data, _, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for \(self.photoReference): \(error)")
            }
            guard let data = data else { return }
            self.imageData = data
        }
        task.resume()
        dataTask = task
        
        guard let largeImage = photoReference.large.usingHTTPS else { return }
        let taskTwo = session.dataTask(with: largeImage) { (data, _, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for \(self.photoReference): \(error)")
            }
            guard let data = data else { return }
            self.imageDataTwo = data
        }
        task.resume()
        dataTaskTwo = taskTwo
    }

    override func cancel() {
        dataTask?.cancel()
        dataTaskTwo?.cancel()
        super.cancel()
    }
    
}
