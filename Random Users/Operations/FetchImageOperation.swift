//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Dillon McElhinney on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

/// Defines the options available for fetching a photo
enum FetchPhotoOption: String {
    case thumbail
    case large
}

/// Fetches the photo for the given contact and option
class FetchImageOperation: ConcurrentOperation {
    
    // MARK: - Properties
    var imageData: Data?
    let contact: Contact
    let fetchPhotoOption: FetchPhotoOption
    private var dataTask: URLSessionDataTask?
    
    // MARK: - Initializers
    init(contact: Contact, option: FetchPhotoOption = .thumbail) {
        self.contact = contact
        self.fetchPhotoOption = option
        super.init()
    }
    
    // MARK: Operation
    override func start() {
        state = .isExecuting
        
        // Set the URL depending on the option passed in. Default it thumbnail since it is way more common.
        var url: URL?
        switch fetchPhotoOption {
        case .thumbail:
            url = contact.thumbnailURL
        case .large:
            url = contact.imageURL
        }
        guard let requestURL = url else { return }
        
        // Make a data task to fetch the image
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
            
            // Set the imageData to the returned data
            self.imageData = data
            return
        })
        
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
}
