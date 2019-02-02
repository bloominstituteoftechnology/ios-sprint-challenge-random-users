//
//  PhotoFetchOperation.swift
//  Astronomy
//
//  Created by Sergey Osipyan on 1/31/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
//    private var userReferences: RandomUsersModel
//    var thumbnailImage: Data?
//    private var task: URLSessionDataTask?
//    typealias ComplitionHandler = (Error?) -> Void
//
//    init(userReferences: RandomUsersModel) {
//
//        self.userReferences = userReferences
//        super.init()
//
//    }
//
//
//    override func start() {
//        super.start()
//        self.state = .isExecuting
//         let url = userReferences.picture.thumbnail
//        task = URLSession.shared.dataTask(with: url) { (data, _, error) in
//
//            if let error = error {
//
//                NSLog("\(error)")
//                return
//            }
//
//            guard let photoData = data else { return }
//            self.thumbnailImage = photoData
//        }
//
//
//
//        self.state = .isFinished
//        task?.resume()
//        }
//
//
//
//    override func cancel() {
//        task?.cancel()
//        super.cancel()
//    }
//
//
//
}
