//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Cora Jacobson on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class FetchPhotoOperation: ConcurrentOperation {
    var user: User
    var imageType: ImageType
    var imageData: Data?
    
    init(user: User, imageType: ImageType) {
        self.user = user
        self.imageType = imageType
    }
    
    private var dataTask: URLSessionDataTask?
    
    override func start() {
        state = .isExecuting
        var imageString: String
        switch imageType {
        case .large:
            imageString = user.large
        default:
            imageString = user.thumbnail
        }
        guard let url = URL(string: imageString) else {
            state = .isFinished
            return
        }
        let request = URLRequest(url: url)
        dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            defer {
                self.state = .isFinished
            }
            if let error = error {
                print("Error fetching photo: \(error)")
                return
            } else {
                if let data = data {
                    self.imageData = data
                    return
                }
            }
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        state = .isFinished
    }
    
}
