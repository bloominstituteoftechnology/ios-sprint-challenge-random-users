//
//  PhotoFetchOp.swift
//  Random Users
//
//  Created by Thomas Sabino-Benowitz on 2/19/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//
import Foundation

import UIKit

class FetchPhotoOperation: ConcurrentOperation {
    
    
    
    let user: User
    // private set means it can only be changed inside of this class
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
