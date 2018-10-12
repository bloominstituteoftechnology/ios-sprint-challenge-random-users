//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Scott Bennett on 10/12/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit

class FetchPhotoOperation: ConcurrentOperation
{
    var imageData: UIImage!
    var task: URLSessionDataTask!
    var url: URL
    
    init(_ url:URL)
    {
        self.url = url
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        task = URLSession.shared.dataTask(with: self.url) { data, _, error in
            defer { self.state = .isFinished}
            if let error = error {
                NSLog("Error loading image: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No image data error")
                return
            }
            
            if let image = UIImage(data: data) {
                self.imageData = image
                return
            } else {
                NSLog("Error decoding image")
                return
            }
        }
        task.resume()
    }
    
    override func cancel() {
        if let task = task {
            task.cancel()
        }
    }
}
