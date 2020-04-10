//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Tobi Kuyoro on 10/04/2020.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    private var dataTask: URLSessionDataTask?
    
    var contact: Contact
    var imageData: Data?
    
    init(contact: Contact) {
        self.contact = contact
    }
    
    override func start() {
        state = .isExecuting
        loadImage()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
    
    func loadImage() {
        let url = contact.thumbnail
        
        dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            defer { self.state = .isFinished }
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                return
            }
            
            guard let data = data else { return }
            self.imageData = data
        }
        
        dataTask?.resume()
    }
}
