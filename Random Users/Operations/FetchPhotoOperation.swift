//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Jesse Ruiz on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {

    var user: Users
    var imageData: Data?
    private var session: URLSessionDataTask?

    init(user: Users) {
        self.user = user
        super.init()
    }

    override func start() {
        state = .isExecuting

        let url = user.picture.large

        session = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            defer { self.state = .isFinished }
            
            if let error = error {
                NSLog("Error fetching photo: \(error)")
                return
            }
            self.imageData = data
        })
        session?.resume()
    }

    override func cancel() {
        session?.cancel()
    }

}


















