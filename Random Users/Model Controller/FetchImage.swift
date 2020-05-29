//
//  FetchImage.swift
//  Random Users
//
//  Created by Christopher Aronson on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchImage: ConcurrentOperation {
    
    var imageURL: URL?
    var imageData: Data?
    
    init(url: URL) {
        self.imageURL = url
    }
    
    override func start() {
        if isCancelled {
            state = .isFinished
            return
        }
        
        state = .isExecuting
        main()
    }
    
    override func cancel() {
        state = .isFinished
    }
    
    override func main() {
        guard let url = imageURL else {
            self.state = .isFinished
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                NSLog("Error while trying to fetch image: \(error)")
                self.state = .isFinished
                return
            }
            
            guard let data = data else {
                NSLog("No data sent back from server")
                self.state = .isFinished
                return
            }
            
            self.imageData = data
            
            self.state = .isFinished
            }.resume()
    }
}
