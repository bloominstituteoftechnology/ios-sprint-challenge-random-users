//
//  PhotoFetchOperation.swift
//  Random Users
//
//  Created by Enrique Gongora on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    // MARK: - Variables
    let user: User
    private let session: URLSession
    private (set) var imageData: Data?
    private var dataTask: URLSessionDataTask?
    
    // MARK: - Functions
    override func start() {
        state = .isExecuting
        let imageURL = user.thumbnailImage
        let request = URLRequest(url: imageURL)
        dataTask = session.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error retrieving data: \(error)")
                return
            }
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            self.imageData = data
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
    // MARK: - Initializer
    init(user: User, session: URLSession = .shared) {
        self.user = user
        self.session = session
        super.init()
    }
    
}
