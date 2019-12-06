//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Jonalynn Masters on 12/6/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
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
        fetchLargePhoto()
    }

    private func fetchLargePhoto() {
        let url = user.picture.large

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
    }
}
