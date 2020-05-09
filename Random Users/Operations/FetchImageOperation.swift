//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Mark Poggi on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImageOperation: ConcurrentOperation {

    // MARK: - Properties

    var user: User
    private (set) var imageData: Data?

    private let session: URLSession
    private var dataTask: URLSessionDataTask?

    init(userRandom: User, session: URLSession = URLSession.shared) {
        self.user = userRandom
        self.session = session
        super.init()
    }

    // MARK: - Methods
    
    override func start() {
        state = .isExecuting
        guard let imageURL = user.thumbnail else { return }

        let task = session.dataTask(with: imageURL) { (data, _, error) in
            defer { self.state = .isFinished }

            if let error = error {
                NSLog("Error fetching data for: \(error)")
                return
            }
            guard let data = data else { return }
            self.imageData = data
        }
        task.resume()

    }

    override func cancel() {
        dataTask?.cancel()
    }
}
