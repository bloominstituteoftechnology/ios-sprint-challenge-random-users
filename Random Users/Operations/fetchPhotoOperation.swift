//
//  fetchPhotoOperation.swift
//  Random Users
//
//  Created by scott harris on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    let contact: Contact
    var imageData: Data?
    var thumbnailData: Data?
    
    private var dataTask: URLSessionDataTask?
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    override func start() {
        state = .isExecuting
         
        dataTask = URLSession.shared.dataTask(with: contact.thumbnailURL, completionHandler: { (data, response, error) in
            defer {
                self.state = .isFinished
            }
            
            if let error = error {
                NSLog("Error received from network: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("Unsuccessful status code received, status code was: \(response.statusCode)")
                return
            }
            
            guard let data = data else {
                NSLog("No data received")
                return
            }
            
            self.thumbnailData = data
        })
        
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
    
}
