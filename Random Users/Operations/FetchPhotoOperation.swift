//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by BrysonSaclausa on 9/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchContactPhotoOperation: ConcurrentOperation{
    // MARK: - Properties
    var contact: Contact
    var imageData: Data?
    private var loadImageTask: URLSessionDataTask?
    
    // MARK: - Initalization
    init(contact: Contact){
        self.contact = contact
        super.init()
    }
    
    // MARK: - Functions
    override func start() {
        self.state = .isExecuting
        
        let imageURL = URL(string: contact.picture.thumbnail)!
        
        loadImageTask = URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, _, error) in
            defer{
                self.state = .isFinished
            }
            if let error = error{
                print("Error getting image: \(error)")
            }
            guard let data = data else{
                print("Error getting data")
                return
            }
            self.imageData = data
        })
        loadImageTask?.resume()
    }
    
    override func cancel() {
        loadImageTask?.cancel()
        self.state = .isFinished
    }
}

