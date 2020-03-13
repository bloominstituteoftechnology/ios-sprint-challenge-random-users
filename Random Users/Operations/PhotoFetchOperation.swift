//
//  PhotoFetchOperation.swift
//  Random Users
//
//  Created by Nick Nguyen on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class PhotoFetchOperation: ConcurrentOperation {
    
    let photoReference: String
    private(set) var imageData: Data?
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    
    init(photoReference: String, session: URLSession = URLSession.shared)
     {
        self.photoReference = photoReference
        self.session = session
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        
        guard let photoURL = URL(string: photoReference) else { return }
        guard let securePhotoURL = photoURL.usingHTTPS else { return }
        
        let task = session.dataTask(with: securePhotoURL) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            defer { self.state = .isFinished }
            
            if let data = data {
                self.imageData = data
            }
            
        }
        
        
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
}
