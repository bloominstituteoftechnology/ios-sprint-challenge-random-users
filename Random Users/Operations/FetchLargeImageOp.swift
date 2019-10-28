//
//  FetchLargeImageOp.swift
//  Random Users
//
//  Created by Lisa Sampson on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class FetchLargeImageOp: ConcurrentOperation {
    
    // MARK: - Properties
    var randomUser: RandomUser
    var largeImage: UIImage?
    private var dataTask: URLSessionDataTask?
    
    // MARK: - Init
    init(randomUser: RandomUser) {
        self.randomUser = randomUser
    }
    
    // MARK: - Start and Cancel
    override func start() {
        state = .isExecuting
        
        let url = randomUser.largeImageURL
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            defer { self.state = .isFinished }
            
            if let error = error {
                NSLog("Error retrieving image: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error finding data.")
                return
            }
            
            guard let largeImage = UIImage(data: data) else {
                NSLog("Error trying to construct image from url.")
                return
            }
            self.largeImage = largeImage
        }
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
}
