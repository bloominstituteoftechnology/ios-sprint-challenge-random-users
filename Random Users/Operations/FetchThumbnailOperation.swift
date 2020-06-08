//
//  FetchThumbnailOperation.swift
//  Random Users
//
//  Created by Cody Morley on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchThumbnailOperation: ConcurrentOperation {
    //MARK: - Properties -
    let user: User
    var imageData: Data?
    var imageTask: URLSessionTask?
    
    
    //MARK: - Initialiazers -
    init(user: User) {
        self.user = user
        super.init()
    }
    
    
    //MARK: - Actions -
    override func start() {
        state = .isExecuting
        let thumbnailURL = user.thumbnailImage
        let fetchThumbnail = URLSession.shared.dataTask(with: thumbnailURL) { data, _, error in
            defer { self.state = .isFinished }
            if let error = error {
                NSLog("Something went terribly wrong during the FetchThumbnailOperation for user: \(self.user.name) Here's some more info: \(error) \(error.localizedDescription)")
                return
            }
            
            guard let thumbnailData = data else {
                NSLog("No thumbnail data returned from url: \(thumbnailURL)")
                return
            }
            self.imageData = thumbnailData
        }
        fetchThumbnail.resume()
        imageTask = fetchThumbnail
    }
    
    override func cancel() {
        imageTask?.cancel()
        super.cancel()
        print("Canceled thumbnail fetch operation for: \(self.user.name)")
    }
    
    
}
