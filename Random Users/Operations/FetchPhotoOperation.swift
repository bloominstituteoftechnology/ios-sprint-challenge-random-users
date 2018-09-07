//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Andrew Liao on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class FetchThumbNailOperation: ConcurrentOperation {
    
    init(user: User){
        self.user = user
    }
    
    override func start() {
        self.state = .isExecuting
        
        let thumbURL = URL(string: user.thumbnailURL)!
        thumbDataTask = URLSession.shared.dataTask(with: thumbURL, completionHandler: { (data, _, error) in
            if let error = error {
                NSLog("Error fetching large photo: \(error)")
            }
            self.thumbData = data
            defer {
                self.state = .isFinished
            }
        })
        thumbDataTask?.resume()
        //TODO: let photoURL = URL(string: user.photoURL)!
    }
    override func cancel() {
        thumbDataTask?.cancel()
    }
    
    
    
    //MARK: - Properties
    let user:User
    var photoData: Data?
    var thumbData: Data?
    
    private(set) var photoDataTask: URLSessionDataTask?
    private(set) var thumbDataTask: URLSessionDataTask?
}
