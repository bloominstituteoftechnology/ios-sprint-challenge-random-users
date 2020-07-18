//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Morgan Smith on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {

    let contactImageUrl: String
    var imageData: Data?
    private var dataTask: URLSessionDataTask?

    override func start() {
        state = .isExecuting
        guard let url = URL(string: contactImageUrl) else {return}

        dataTask = URLSession.shared.dataTask(with: url){ (data, _, error) in
            if let error = error {
                print("Error fetching image: \(error)")
                return
            }

            guard let data = data else { return }
            self.imageData = data
            do {self.state = .isFinished}
        }

        dataTask?.resume()
    }

    override func cancel() {
        dataTask?.cancel()
    }

    init(contactImageUrl: String) {
        self.contactImageUrl = contactImageUrl
    }
}

