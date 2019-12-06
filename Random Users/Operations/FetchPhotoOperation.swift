//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_204 on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    let photoReference: String
    var imageData: Data?
    private var dataTask: URLSessionDataTask?
    
    init(photoReference: String) {
        self.photoReference = photoReference
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        
        guard let thumbNailURL = URL(string: photoReference)?.usingHTTPS
            else { return }
        //guard let imageURL = photoReference.imageURL.usingHTTPS else { return }
        
        dataTask = URLSession.shared.dataTask(with: thumbNailURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data for \(self.photoReference): \(error)")
            }
            
            guard let data = data else { return }
            
            self.imageData = data
            self.state = .isFinished
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
}
