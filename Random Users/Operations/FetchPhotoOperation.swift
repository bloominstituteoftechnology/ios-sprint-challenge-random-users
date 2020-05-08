//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Hunter Oppel on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    var user: User
    var imageData: Data?
    
    init(user: User) {
        self.user = user
    }
    
    override func start() {
        state = .isExecuting
        
        loadImageDataTask.start()
    }
    
    override func cancel() {
        loadImageDataTask.cancel()
        print("Canceled fetching \(user.name.fullName)'s photo")
    }
    
    private lazy var loadImageDataTask = BlockOperation {
        guard let imageURL = URL(string: self.user.picture.thumbnail) else { return }
        
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            defer { self.state = .isFinished }
            if let error = error {
                NSLog("Failed to fetch photo with error: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("\(imageURL) returned no data")
                return
            }
            
            self.imageData = data
        }.resume()
    }
    
}
