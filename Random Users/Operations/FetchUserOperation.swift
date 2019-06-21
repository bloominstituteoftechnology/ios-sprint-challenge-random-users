//
//  FetchUserOperation.swift
//  Random Users
//
//  Created by Thomas Cacciatore on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


class FetchUserOperation: ConcurrentOperation {

    init(user: User, session: URLSession = URLSession.shared) {
        self.user = user
        self.session = session
        super.init()
    }

    override func start() {
        state = .isExecuting
        let url = user.smallImageURL
        
        let task = session.dataTask(with: url) { (data, response, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for \(self.user): \(error)")
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

    let user: User
    private let session: URLSession
    private(set) var imageData: Data?
    private var dataTask: URLSessionDataTask?
}
