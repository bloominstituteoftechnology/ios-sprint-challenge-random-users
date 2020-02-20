//
//  FetchUserOperation.swift
//  Random Users
//
//  Created by Jorge Alvarez on 2/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    // MARK: Properties
    
    let photoReference: User
    
    private let session: URLSession

    private(set) var imageData: Data?
    
    private var dataTask: URLSessionDataTask?
    
    init(photoReference: User, session: URLSession = URLSession.shared) {
        self.photoReference = photoReference
        self.session = session
        super.init()
    }
 
    override func start() {
        state = .isExecuting
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
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
}
