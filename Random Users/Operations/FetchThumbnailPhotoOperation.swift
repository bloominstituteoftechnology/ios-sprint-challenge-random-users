//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Mitchell Budge on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchThumbnailPhotoOperation: ConcurrentOperation {
    
    init(user: User, session: URLSession = URLSession.shared) {
        self.user = user
        self.session = session
    }
    
    override func start() {
        state = .isExecuting
        let url = (user.thumbnailImageURL)
        
        let task = session.dataTask(with: url) { (data, _, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching image: \(error)")
                return
            }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            self.thumbnailImage = image
        }
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
    // MARK: Properties
    
    var user: User
    var thumbnailImage: UIImage?
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
}

