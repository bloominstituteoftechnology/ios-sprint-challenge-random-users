//
//  FetchUsersOperation.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_259 on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchUsersOperation: ConcurrentOperation {
    let user: User
    var imageData: Data?
    
    private var dataTask: URLSessionDataTask {
        let imageURL: URL = URL(string: user.picture.thumbnail)!
        return URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                return
            }
            self.imageData = data
            defer { self.state = .isFinished }
        }
    }
    
    init(user: User) {
        self.user = user
    }
    
    override func start() {
        state = .isExecuting
        
        dataTask.resume()
    }
    
    override func cancel() {
        dataTask.cancel()
    }
}
