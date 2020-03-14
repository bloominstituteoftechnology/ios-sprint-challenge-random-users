//
//  PhotoFetchOperation.swift
//  Random Users
//
//  Created by Nick Nguyen on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class PhotoFetchOperation: ConcurrentOperation {

    var user: User
    var imageData: Data?
    private var dataTask: URLSessionDataTask?

    init(user: User) {
        self.user = user
       
    }

    override func start() {
        state = .isExecuting
        fetchThumbNailPhoto()
    }

    private func fetchThumbNailPhoto() {
        
        let url = user.thumbNailImage

        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            defer { self.state = .isFinished }

            if let error = error {
                print("Error fetching large photo: \(error)")
                return
            }
            self.imageData = data
        })
        dataTask?.resume()
    }

    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}

