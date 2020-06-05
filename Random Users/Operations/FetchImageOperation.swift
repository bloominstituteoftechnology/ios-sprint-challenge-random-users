//
//  FetchUserOperation.swift
//  Random Users
//
//  Created by Harmony Radley on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImageOperation: ConcurrentOperation {

    // MARK: - Properties

    var user: User
    private (set) var imageData: Data?
    private var dataTask = URLSessionDataTask()
    private let session: URLSession

    init(user: User, session: URLSession = URLSession.shared)  {
        self.user = user
        self.session = session
        super.init()
    }

    // MARK: - Methods

    override func start() {
        if isCancelled { return }

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
        dataTask = task
    }

    override func cancel() {
        dataTask.cancel()
    }
}
