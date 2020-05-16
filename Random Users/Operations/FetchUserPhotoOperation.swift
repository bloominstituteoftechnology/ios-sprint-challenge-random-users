//
//  FetchUserOperation.swift
//  Random Users
//
//  Created by Claudia Contreras on 5/16/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchUserPhotoOperation: ConcurrentOperation {
    var userReference: UserResults
    var imageData: Data?
    
    private var loadImageDataTask: URLSessionDataTask?
    
    init(userReference: UserResults) {
        self.userReference = userReference
    }
    
    override func start() {
        state = .isExecuting
        
        defer { state = .isFinished }
        
        let imageURL = URL(string: userReference.picture.thumbnail)!
        
        loadImageDataTask = URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
                if let error = error {
                    NSLog("Error fetching image: \(error)")
                    return
                }
                
                guard let data = data else {
                    NSLog("Error fetching data")
                    return
                }

                self.imageData = data
            }

        loadImageDataTask?.resume()
        }

    override func cancel() {
        loadImageDataTask?.cancel()
    }
}
