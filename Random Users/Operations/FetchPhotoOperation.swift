//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Bronson Mullens on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    // MARK: - Initializers
    
    init(contact: Contact) {
        self.contact = contact
        super.init()
    }
    
    // MARK: - Properties
    
    private var loadImageTask: URLSessionDataTask?
    var contact: Contact
    var imageData: Data?
    
    override func start() {
        self.state = .isExecuting
        
        let imageURL = URL(string: contact.picture.thumbnail)!
        
        loadImageTask = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, _, error) in
            defer {
                self.state = .isFinished
            }
            
            if let imageError = error {
                NSLog("Error: \(imageError.localizedDescription)")
            }
            
            guard let imageData = data else {
                NSLog("Error fetching image data")
                return
            }
            
            self.imageData = imageData
            
        })
        loadImageTask?.resume()
    }
    
    override func cancel() {
        loadImageTask?.cancel()
        self.state = .isFinished
    }
    
}
