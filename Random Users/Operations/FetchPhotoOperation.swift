//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Niranjan Kumar on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    var user: User
    var imageData: Data?
    private var dataTask: URLSessionDataTask?
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        
        let url = user.picture.large
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            defer { self.state = .isFinished }
            
            if let error = error {
                NSLog("Error fetching data for \(self.user): \(error)")
                print("\(#file):L\(#line): Code failed inside \(#function)")
                return
            }
                    
            self.imageData = data
        })
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
}
