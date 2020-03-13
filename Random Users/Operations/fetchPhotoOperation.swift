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
    
    private var thumbnailDataTask: URLSessionDataTask?
    private var imageDataTask: URLSessionDataTask?
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    override func start() {
        getThumbNail()
        getFullImage()
    }
    
    override func cancel() {
        thumbnailDataTask?.cancel()
        imageDataTask?.cancel()
        
    }
    
    func getThumbNail() {
        state = .isExecuting
        
        thumbnailDataTask = URLSession.shared.dataTask(with: contact.thumbnailURL, completionHandler: { (data, response, error) in
            
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
        
        thumbnailDataTask?.resume()
        
    }
    
    func getFullImage() {
        state = .isExecuting
        
        imageDataTask = URLSession.shared.dataTask(with: contact.imageURL, completionHandler: { (data, response, error) in
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
            
            self.imageData = data
        })
        
        imageDataTask?.resume()
        
    }
    
}
