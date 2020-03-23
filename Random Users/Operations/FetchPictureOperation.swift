//
//  FetchPictureOperation.swift
//  Random Users
//
//  Created by David Wright on 3/23/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class FetchPictureOperation: ConcurrentOperation {
    
    // MARK: - Properties

    var imageURL: URL
    
    var imageData: Data?
    
    private lazy var dataTask: URLSessionDataTask? = {
        return URLSession.shared.dataTask(with: imageURL) { data, _, error in
            defer { self.state = .isFinished }
            
            guard error == nil else { print("Error fetching image from url: \(error!)"); return }
            guard let data = data else { print("No data returned by data task."); return }

            self.imageData = data
        }
    }()
    
    // MARK: - Methods
    
    override func cancel() {
        dataTask?.cancel()
    }
    
    override func start() {
        state = .isExecuting
        dataTask?.resume()
    }
    
    // MARK: - Initializers
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        super.init()
    }
}
