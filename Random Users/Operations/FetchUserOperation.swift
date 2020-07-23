//
//  FetchUserOperation.swift
//  Random Users
//
//  Created by Ian French on 7/19/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


class FetchUserImageOperation: ConcurrentOperation {

    var user: UserResults
    var imageData: Data?

    private var loadImageData: URLSessionDataTask?

    init(user: UserResults) {
        self.user = user
    }

    override func start() {
            state = .isExecuting

            defer { state = .isFinished }

            let imageURL = URL(string: user.picture.thumbnail)!

            loadImageData = URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
                    if let error = error {
                        NSLog("Error fetching image: \(error)")
                        return
                    }

                    guard let data = data else {
                        NSLog("Error fetching data")
                        return
                    }

                    self.imageData = data
                }

            loadImageData?.resume()
            }

        override func cancel() {
            loadImageData?.cancel()

    }
}
