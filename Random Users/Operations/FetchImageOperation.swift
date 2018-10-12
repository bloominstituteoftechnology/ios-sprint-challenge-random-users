//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Dillon McElhinney on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

enum FetchPhotoOption: String {
    case thumbail
    case large
}

class FetchImageOperation: ConcurrentOperation {
    var imageData: Data?
    let contact: Contact
    let fetchPhotoOption: FetchPhotoOption
    private var dataTask: URLSessionDataTask?
    
    init(contact: Contact, option: FetchPhotoOption = .thumbail) {
        self.contact = contact
        self.fetchPhotoOption = option
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        
        var url: URL?
        switch fetchPhotoOption {
        case .thumbail:
            url = contact.thumbnailURL
        case .large:
            url = contact.imageURL
        }
        guard let requestURL = url else { return }
        
        dataTask = URLSession.shared.dataTask(with: requestURL, completionHandler: { (data, _, error) in
            defer { self.state = .isFinished }
            if let error = error {
                NSLog("Error GETing image for \(self.contact.name): \(error)")
                return
            }
            
            guard let data = data, data.count > 0 else {
                NSLog("No data was returned")
                return
            }
            
            self.imageData = data
            return
        })
        
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
}
