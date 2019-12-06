//
//  FetchPhotosOperation.swift
//  Random Users
//
//  Created by morse on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    let photoString: String
        private(set) var imageData: Data?
        private let session: URLSession
        private var dataTask: URLSessionDataTask?
        
        init(photoString: String, session: URLSession = URLSession.shared) {
            self.photoString = photoString
            self.session = session
        }
        
        override func start() {
            state = .isExecuting
            guard let photoURLPreview = URL(string: photoString),
                let photoURL = photoURLPreview.usingHTTPS else { return }
            
            dataTask = session.dataTask(with: photoURL) { (data, _, error) in
                defer { self.state = .isFinished }
                if self.isCancelled { return }
                if let error = error {
                    print("Error fetching \(self.photoString) data: \(error)")
                    return
                }
                
                if let data = data {
                    self.imageData = data
                }
            }
            dataTask?.resume()
        }
        
        override func cancel() {
    //        print("cancel")
            dataTask?.cancel()
    //        print("cancelled")
        }
}
