//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Sammy Alvarado on 9/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FethchPhotoOperation: ConcurrentOperation {

    var user: Users
    var imageData: Data?
    var task: URLSessionDataTask?

    init(userImage: Users) {
        self.user = userImage
    }

    override func start() {
        state = .isExecuting

        guard let imageURL = URL(string: user.picture.thumbnail) else {
            return
        }

//        task = URLSession.shared.dataTask(with: user.picture.thumbnail) { (data, _, error) in
//            defer {
//                self.state = .isFinished
//            }
//
//            if let error = error {
//                print("Failed to get imageURL \(error)")
//                return
//            }
//
//            guard let data = data else {
//                print("no data")
//                return
//            }
//
//            self.imageData = data
//
//        }
//        task?.resume()
    }

    override func cancel() {
        task?.cancel()
        self.state = .isFinished
    }
}
