//
//  ImageFetch.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 7/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

enum imageSize {
    case thumbnail
    case fullsize
}

class ImageFetch: ConcurrentOperation {
    
    private let userImage: User
    private let imageSize: imageSize
    private let urlSession: URLSession
    private var urlDataTask: URLSessionDataTask?
    private(set) var imageResults: UIImage?
    private(set) var imageError: Error?
    
    
    init(userImage: User, imageSize: imageSize, urlSession: URLSession = URLSession.shared) {
        self.userImage = userImage
        self.imageSize = imageSize
        self.urlSession = urlSession
        super.init()
    }
    
    override func cancel() {
        urlDataTask?.cancel()
        super.cancel()
    }
    
    override func start() {
        if isCancelled { return }
        
        state = .isExecuting
        
        fetchImageURL()
    }
    
    private func fetchImageURL() {
        guard let url = fetchImageSize(imageSize: imageSize, user: userImage) else {
            imageError = NSError()
            state = .isFinished
            return
        }
        
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for: \(error)")
                self.imageError = error
                return
            }
            
            guard let data = data else {
                NSLog("Received no data")
                self.imageError = NSError()
                return
            }
            
            self.imageResults = UIImage(data: data)
        }
        task.resume()
        urlDataTask = task
    }
    
    private func fetchImageSize(imageSize: imageSize, user: User) -> URL? {
        switch imageSize {
        case .thumbnail:
            return URL(string: user.picture.thumbnail)
        case .fullsize:
            return URL(string: user.picture.large)
        }
    }
}
