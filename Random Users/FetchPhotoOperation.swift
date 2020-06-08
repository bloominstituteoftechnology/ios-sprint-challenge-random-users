//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Kelson Hartle on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum ImageType {
    case thumbnail
    case large
    
}

class FetchPhotoOperation: ConcurrentOperation {
    
    let photoReference: User
    private(set) var imageData: Data?
    private(set) var imageDataTwo: Data?
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    private var dataTaskTwo: URLSessionTask?
    var imageType: ImageType
    
    init(photoReference: User, session: URLSession = URLSession.shared, imageType: ImageType) {
        self.photoReference = photoReference
        self.session = session
        self.imageType = imageType
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        
        if imageType == .thumbnail {
            guard let thumbNailImage = photoReference.thumbnail.usingHTTPS else { return }
            print(thumbNailImage)
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
        } else if imageType == .large {
            guard let largeImage = photoReference.large.usingHTTPS else { return }
            print(largeImage)
            let taskTwo = session.dataTask(with: largeImage) { (data, _, error) in
                defer { self.state = .isFinished }
                if self.isCancelled { return }
                if let error = error {
                    NSLog("Error fetching data for \(self.photoReference): \(error)")
                }
                guard let data = data else { return }
                self.imageDataTwo = data
            }
            taskTwo.resume()
            dataTask = taskTwo
        } 
    }

    override func cancel() {
        dataTask?.cancel()
        dataTaskTwo?.cancel()
        super.cancel()
    }
    
}
