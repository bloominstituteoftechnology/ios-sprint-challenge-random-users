//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Bobby Keffury on 11/13/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    // MARK: - Properties
    
    let user: User?
    
    private let session: URLSession

    private(set) var imageData: Data?
    
    private var dataTask: URLSessionDataTask?
    
    // MARK: - Functions
    
    init(user: User, session: URLSession = URLSession.shared) {
        self.user = user
        self.session = session
        super.init()
    }
    
    override func start() {
        guard let user = user else { return }
        state = .isExecuting
        let url = user.picture.thumbnail
        
        let task = session.dataTask(with: url) { (data, response, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for \(user): \(error)")
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
    
    
}
