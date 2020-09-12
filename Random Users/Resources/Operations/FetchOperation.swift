//
//  FetchOperation.swift
//  Random Users
//
//  Created by John McCants on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchOperation: ConcurrentOperation {
    var contact: Contact?
    var imageData : Data?
    var task : URLSessionDataTask?
    
    init(contact: Contact) {
        self.contact = contact
        super.init()
    }
    
    
    
    override func start() {
        state = .isExecuting
        guard let contact = contact else {
            return
        }
        
        guard let imageURL = URL(string: contact.picture.thumbnail) else {
            return
        }
        
        self.task = URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            
            defer {
                           self.state = .isFinished
                   }
            
            if let error = error {
                print("Error fetching image: \(error)")
                return
            }
            guard let data = data else {
                print("No data returned from fetch")
                return
            }
            
            self.imageData = data
           
        
        }
        task?.resume()
    }
    
    override func cancel() {
        task?.cancel()
        self.state = .isFinished
    }
}
