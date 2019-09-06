//
//  FetchPhotoOperation.swift
//  RandomUsersSprint
//
//  Created by Luqmaan Khan on 9/6/19.
//  Copyright © 2019 Luqmaan Khan. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    var user: User
    var imageData: Data?
    private var dataTask: URLSessionDataTask?
    
    init(user: User) {
        self.user = user
        super.init()
    }
    override func start() {
        state = .isExecuting
        dataTask = URLSession.shared.dataTask(with: user.thumbnail ) { (data, _, error) in
            defer {self.state = .isFinished}
            if let error = error {
                NSLog("Error: \(error)")
                return
            }
            guard let data = data else {return}
            self.imageData = data
        }
        dataTask?.resume()
    }
    override func cancel() {
        dataTask?.cancel()
    }
    
    
    
    
}
