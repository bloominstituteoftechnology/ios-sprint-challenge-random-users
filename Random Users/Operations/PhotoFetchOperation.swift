//
//  PhotoFetchOperation.swift
//  Random Users
//
//  Created by Michael on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    
    // MARK: - Properties
    let contact: Contact
    
    private let session: URLSession
    
    private(set) var imageData: Data?
    
    private var dataTask: URLSessionDataTask?
    
    override func start() {
        state = .isExecuting
        let imageURL = contact.thumbnailImage
        let request = URLRequest(url: imageURL)
        let task = session.dataTask(with: request) { data, _, error in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error retrieving data for \(self.contact) from server: \(error)")
                return
            }
            self.imageData = data
        }
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
    init(contact: Contact, session: URLSession = .shared) {
        self.contact = contact
        self.session = session
        super.init()
    }
}
