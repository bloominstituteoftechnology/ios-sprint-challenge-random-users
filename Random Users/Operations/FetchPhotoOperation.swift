//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Sammy Alvarado on 9/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImageOperation: ConcurrentOperation {
    
    var user: UsersResults
    var imageData: Data?
    
    private var loadImageData: URLSessionTask?
    
    init(user: UsersResults) {
        self.user = user
    }
    
    override func start() {
        state = .isExecuting
        defer { state = .isFinished }
        // user.picture.thumbnail
        let imageURL = URL(string: user.picture.thumbnail)!
        loadImageData = URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                print("Error fetching Image: \(error)")
                return
            }
            guard let data = data else {
                print("Error")
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
