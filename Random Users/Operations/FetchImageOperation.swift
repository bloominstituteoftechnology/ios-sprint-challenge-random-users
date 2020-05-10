//
//  FetchThumbnailOperation.swift
//  Random Users
//
//  Created by Jonathan Ferrer on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

import Foundation

class FetchImageOperation: ConcurrentOperation {

    var imageURL: URL?
    var imageData: Data?

    init(url: URL) {
        self.imageURL = url
    }

    override func start() {
        if isCancelled {
            state = .isFinished
            print("Canceling fetch")
            return
        }

        state = .isExecuting
        guard let url = imageURL else {
            self.state = .isFinished
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, error) in

            if let error = error {
                NSLog("Error while trying to fetch image: \(error)")
                self.state = .isFinished
                return
            }

            guard let data = data else {
                NSLog("No data sent back from server")
                self.state = .isFinished
                return
            }

            self.imageData = data

            self.state = .isFinished
            }.resume()
    }

    override func cancel() {
        state = .isFinished
    }

    
}
