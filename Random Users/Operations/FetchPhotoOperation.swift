//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Chris Dobek on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {

    var user: User
    private var dataTask = URLSessionDataTask()
    var imageData: Data?
    var imageIsThumbnail = true

    init(user: User, imageIsThumbnail: Bool) {
        self.user = user
        self.imageIsThumbnail = imageIsThumbnail
    }

    override func start() {
        state = .isExecuting

        var url: String?
        switch imageIsThumbnail {
        case true:
            url = user.picture.thumbnail
        default:
            url = user.picture.large
        }

        dataTask = URLSession.shared.dataTask(with: URL(string: url!)!, completionHandler: { (data, response, error) in
            if let error = error { print(error) }
            guard let data = data else { return }
            self.imageData = data
            self.state = .isFinished
        })
        dataTask.resume()
    }

    override func cancel() {
        dataTask.cancel()
    }

}
