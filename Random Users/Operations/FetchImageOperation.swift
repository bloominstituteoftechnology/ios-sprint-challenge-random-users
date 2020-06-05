//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Joe Veverka on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImageOperation: ConcurrentOperation {

    //MARK: - Private

    private var fetchImageTask: URLSessionDataTask?

    //MARK: - Properties

    let imageURL: URL
    var imageData: Data?

    //MARK: - Init

    init(imageURL: URL) {
        self.imageURL = imageURL
    }

    //MARK: - Overrides

    override func start() {
        state = .isExecuting

        fetchImageTask = URLSession.shared.dataTask(with: imageURL) {
            data, response, error in
            defer { self.state = .isFinished }

            if let error = error {
                print("Error: \(error)")
                return
            }

            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                print("Invalid response: \(response.statusCode)")
                return
            }

            guard let data = data else { return }

            self.imageData = data
        }

        fetchImageTask?.resume()

    }

    override func cancel() {
        fetchImageTask?.cancel()
    }
}
