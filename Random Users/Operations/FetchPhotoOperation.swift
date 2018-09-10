//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Andrew Liao on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    init(user: User){
        self.user = user
    }
    
    override func start() {
        self.state = .isExecuting
        
        let photoURL = URL(string: user.photoURL)!
        photoDataTask = URLSession.shared.dataTask(with: photoURL, completionHandler: { (data, _, error) in
            if let error = error {
                NSLog("Error fetching large photo: \(error)")
            }
            self.photoData = data
            defer {
                self.state = .isFinished
            }
        })
        photoDataTask?.resume()
        //TODO: let photoURL = URL(string: user.photoURL)!
    }
    override func cancel() {
        photoDataTask?.cancel()
    }
    
    
    
    //MARK: - Properties
    let user:User
    var photoData: Data?
    
    private(set) var photoDataTask: URLSessionDataTask?
}
