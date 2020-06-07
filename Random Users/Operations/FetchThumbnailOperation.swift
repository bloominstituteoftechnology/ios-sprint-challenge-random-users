//
//  FetchThumbnailOperation.swift
//  Random Users
//
//  Created by Cody Morley on 6/6/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchThumbnailOperation: ConcurrentOperation {
    //MARK: - Properties -
    let user: User
    var imageData: Data?
    var imageTask: URLSessionTask?
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        
        let imageURL = user.image
        let fetchImage = URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                NSLog("Something went horribly wrong during fetch operation. Here's some data about what happened: \(error) \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                NSLog("No data returned for image: \(imageURL)")
                return
            }
            self.imageData = data
        }
        fetchImage.resume()
        imageTask = fetchImage
    }
    
    override func cancel() {
        imageTask?.cancel()
        super.cancel()
        print("Canceled a thumbnail fetch operation.")
    }
    
    
}
