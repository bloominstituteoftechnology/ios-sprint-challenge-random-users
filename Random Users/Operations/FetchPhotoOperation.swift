//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Jake Connerly on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    let user: User?
    private(set) var imageData: Data?
    
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    
    init(user: User, session: URLSession = URLSession.shared) {
        self.user = user
        self.session = session
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        guard let imageURL = user?.picture.thumbNailURL else { return}
        
        let task = session.dataTask(with: imageURL) { data, _, error in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                
                NSLog("error fetching data in FetchPhotoOperation:\(error)")
            }
            guard let data = data else {
                NSLog("error bad data")
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
