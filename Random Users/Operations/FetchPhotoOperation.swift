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
    private var session: URLSessionDataTask?
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        
        let url = user.picture.large
        
        session = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            defer { self.state = .isFinished }
            
            if let error = error {
                NSLog("Error fetching data for \(self.user): \(error)")
                print("\(#file):L\(#line): Code failed inside \(#function)")
            }
            
            guard let data = data else { return }
            
            self.imageData = data
        })
        session?.resume()
    }
    
    override func cancel() {
        session?.cancel()
        super.cancel()
    }
    
}
