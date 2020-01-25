//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Alex Thompson on 1/25/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    override func start() {
        state = .isExecuting
        guard let url = URL(string: userImageUrl) else { return }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("error fetching image: \(error)")
                return
            }
            
            guard let data = data else { return }
            self.imageData = data
            
            do { self.state = .isFinished }
        }
        
        task?.resume()
    }
    
    override func cancel() {
        task?.cancel()
    }
    
    init(userImageUrl: String) {
    self.userImageUrl = userImageUrl
    
    }
    
    let userImageUrl: String
    var imageData: Data?
    private var task: URLSessionDataTask?
}
