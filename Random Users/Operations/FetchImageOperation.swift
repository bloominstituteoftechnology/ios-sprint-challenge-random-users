//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Ciara Beitel on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImageOperation: ConcurrentOperation {
    
    let imageReference: MarsPhotoReference
    private(set) var imageData: Data?
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    
    init(imageReference: MarsPhotoReference, session: URLSession = URLSession.shared) {
        self.imageReference = imageReference
        self.session = session
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        guard let imageURL = imageReference.imageURL.usingHTTPS else { return }
        let task = session.dataTask(with: imageURL) { (data, _, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for \(self.imageReference): \(error)")
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
