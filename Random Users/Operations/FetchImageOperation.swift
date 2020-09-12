//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Rob Vance on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImageOperation: ConcurrentOperation {
    
    //MARK: - Properties -
    let user: User
    
    private(set) var imageData: Data?
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    
    init(user: User, session: URLSession = URLSession.shared) {
        self.user = user
        self.session = session
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        let imageURL = user.thumbnailImage
        let request = URLRequest(url: imageURL)
        let task = session.dataTask(with: request) { (data, _, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                print("Error fetching data for \(self.user): \(error)")
            }
            guard let data = data else { return }
            self.imageData = data
        }
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
