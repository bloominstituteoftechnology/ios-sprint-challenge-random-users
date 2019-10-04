//
//  DownloadImageOperation.swift
//  Random Users
//
//  Created by Marc Jacques on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


class FetchPhotoOperation: ConcurrentOperation {
    
    var userPicture: Picture
    private(set) var imageData: Data?
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    
    init(userPicture: Picture, session: URLSession = URLSession.shared) {
        self.userPicture = userPicture
        self.session = session
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        let imageURL = userPicture.thumbnail
        let task = session.dataTask(with: imageURL) { (data, _, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for \(self.userPicture): \(error)")
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
