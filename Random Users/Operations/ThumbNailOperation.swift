//
//  ThumbNailOperation.swift
//  Random Users
//
//  Created by Diante Lewis-Jolley on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class ThumbNailOperation: ConcurrentOperation {

    var user: User
    var thumbNailImage: UIImage?
    private var dataTask: URLSessionDataTask?

    init(user: User) {
        self.user = user
    }

    override func start() {
        state = .isExecuting

        let imageUrl = user.thumbNailImageURL

        dataTask = URLSession.shared.dataTask(with: imageUrl) { (data, _, error) in
            defer { self.state = .isFinished }

            if let error = error {
                NSLog("Error fetching images: \(error)")
                return
            }

            guard let data = data else {
                NSLog("No data found")
                return
            }
            self.thumbNailImage = UIImage(data: data)
        }

        dataTask?.resume()

    }

    override func cancel() {
        dataTask?.cancel()
    }
}
