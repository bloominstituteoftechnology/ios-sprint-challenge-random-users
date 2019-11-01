//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Isaac Lyons on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    let reference: URL
    var imageData: Data?
    private var dataTask: URLSessionDataTask?
    
    init(reference: URL) {
        self.reference = reference
    }
    
    override func start() {
        state = .isExecuting
        
        dataTask = URLSession.shared.dataTask(with: reference, completionHandler: { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image: \(error)")
                return
            }
            
            self.imageData = data
            self.state = .isFinished
        })
        
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
        //print("Photo fetch canceled.")
    }
}
